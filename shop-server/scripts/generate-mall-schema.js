const fs = require('fs')
const path = require('path')

const repoRoot = path.resolve(__dirname, '..')
const sourceRoots = [
  'yudao-module-member/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject',
  'yudao-module-pay/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject',
  'yudao-module-mall/yudao-module-product/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject',
  'yudao-module-mall/yudao-module-promotion/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject',
  'yudao-module-mall/yudao-module-trade/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject',
  'yudao-module-mall/yudao-module-statistics/src/main/java/cn/iocoder/yudao/module/statistics/dal/dataobject'
]

const outputFile = path.join(repoRoot, 'sql/mysql/mall-bootstrap/01-mall-schema-current.sql')

function walk(dir) {
  if (!fs.existsSync(dir)) return []
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const fullPath = path.join(dir, entry.name)
    if (entry.isDirectory()) return walk(fullPath)
    if (entry.isFile() && entry.name.endsWith('DO.java')) return [fullPath]
    return []
  })
}

function camelToSnake(value) {
  return value
    .replace(/([a-z0-9])([A-Z])/g, '$1_$2')
    .replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .toLowerCase()
}

function normalizeType(type) {
  return type.replace(/\s+/g, ' ').trim()
}

function escapeSqlComment(comment) {
  return comment.replace(/'/g, "''")
}

function cleanDocLines(lines) {
  return lines
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith('@'))
}

function normalizeComment(lines) {
  return cleanDocLines(lines).join(' ').replace(/\s+/g, ' ').trim()
}

function mysqlType(field) {
  const type = normalizeType(field.type)
  const annotations = field.annotations.join(' ')
  if (/typeHandler\s*=/.test(annotations) || /^(List|Map|Set)\b/.test(type)) return 'longtext'
  if (type === 'String' && /^(property|description)$/.test(field.name)) return 'longtext'
  if (type === 'String') return 'varchar(1024)'
  if (type === 'Long' || type === 'long') return 'bigint'
  if (type === 'Integer' || type === 'int') return 'int'
  if (type === 'Boolean' || type === 'boolean') return 'bit(1)'
  if (type === 'Double' || type === 'double' || type === 'Float' || type === 'float') return 'double'
  if (type === 'BigDecimal') return 'decimal(18,2)'
  if (type === 'LocalDateTime' || type === 'Date') return 'datetime'
  if (type === 'LocalDate') return 'date'
  if (type === 'LocalTime') return 'time'
  if (type === 'Byte' || type === 'byte') return 'tinyint'
  if (type === 'Short' || type === 'short') return 'smallint'
  return 'longtext'
}

function explicitColumnName(annotations) {
  const text = annotations.join(' ')
  const tableField = text.match(/@TableField\s*\(\s*(?:value\s*=\s*)?"([^"]+)"/)
  if (tableField) return tableField[1]
  const tableId = text.match(/@TableId\s*\(\s*(?:value\s*=\s*)?"([^"]+)"/)
  if (tableId) return tableId[1]
  return null
}

function parseEntity(file) {
  const raw = fs.readFileSync(file, 'utf8')
  const lines = raw.split(/\r?\n/)

  const tableLineIndex = lines.findIndex((line) => line.includes('@TableName('))
  if (tableLineIndex < 0) return null
  const tableLine = lines[tableLineIndex]
  const tableMatch = tableLine.match(/@TableName\s*\(\s*(?:value\s*=\s*)?"([^"]+)"/)
  if (!tableMatch) return null

  const classLineIndex = lines.findIndex((line) => /public\s+class\s+\w+\s+extends\s+\w+/.test(line))
  if (classLineIndex < 0) return null
  const classMatch = lines[classLineIndex].match(/public\s+class\s+(\w+)\s+extends\s+(\w+)/)
  if (!classMatch) return null

  const table = tableMatch[1]
  const classComment = (() => {
    let endIndex = classLineIndex - 1
    while (endIndex >= 0 && !lines[endIndex].trim().endsWith('*/')) endIndex -= 1
    if (endIndex < 0) return ''
    let startIndex = endIndex
    while (startIndex >= 0 && !lines[startIndex].trim().startsWith('/**')) startIndex -= 1
    if (startIndex < 0) return ''
    return normalizeComment(
      lines.slice(startIndex + 1, endIndex).map((line) => line.replace(/^\s*\*\s?/, ''))
    ).replace(/\s+DO$/, '').trim()
  })()

  const fields = []
  let inDoc = false
  let pendingDoc = []
  let pendingComment = ''
  let pendingAnnotations = []

  for (const rawLine of lines.slice(classLineIndex + 1)) {
    const line = rawLine.trim()
    if (!line) continue

    if (line.startsWith('/**')) {
      inDoc = true
      pendingDoc = []
      continue
    }

    if (inDoc) {
      if (line.startsWith('*/')) {
        pendingComment = normalizeComment(pendingDoc)
        pendingDoc = []
        inDoc = false
      } else {
        pendingDoc.push(line.replace(/^\*\s?/, ''))
      }
      continue
    }

    if (line.startsWith('@')) {
      pendingAnnotations.push(line)
      continue
    }

    const fieldMatch = line.match(/^private\s+(?!static\b)([A-Za-z0-9_<>, ?\[\]]+)\s+(\w+)\s*(?:=.*)?;$/)
    if (fieldMatch) {
      fields.push({
        type: fieldMatch[1].trim(),
        name: fieldMatch[2],
        annotations: [...pendingAnnotations],
        comment: pendingComment
      })
      pendingAnnotations = []
      pendingComment = ''
      continue
    }

    pendingAnnotations = []
    pendingComment = ''
  }

  return { table, classComment, fields }
}

function columnSql(column) {
  let sql = ''
  if (column.name === 'id') sql = '`id` bigint NOT NULL AUTO_INCREMENT'
  else if (column.name === 'create_time') sql = '`create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP'
  else if (column.name === 'update_time') sql = '`update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'
  else if (column.name === 'creator') sql = "`creator` varchar(64) DEFAULT ''"
  else if (column.name === 'updater') sql = "`updater` varchar(64) DEFAULT ''"
  else if (column.name === 'deleted') sql = "`deleted` bit(1) NOT NULL DEFAULT b'0'"
  else if (column.name === 'tenant_id') sql = '`tenant_id` bigint NOT NULL DEFAULT 0'
  else sql = `\`${column.name}\` ${column.type} DEFAULT NULL`

  if (column.comment) {
    sql += ` COMMENT '${escapeSqlComment(column.comment)}'`
  }
  return sql
}

function buildTableSql(entity) {
  const columns = []
  const seen = new Set()
  for (const field of entity.fields) {
    const name = explicitColumnName(field.annotations) || camelToSnake(field.name)
    if (seen.has(name)) continue
    seen.add(name)
    columns.push({ name, type: mysqlType(field), comment: field.comment })
  }

  if (!seen.has('create_time')) columns.push({ name: 'create_time', comment: '创建时间' })
  if (!seen.has('update_time')) columns.push({ name: 'update_time', comment: '更新时间' })
  if (!seen.has('creator')) columns.push({ name: 'creator', comment: '创建者' })
  if (!seen.has('updater')) columns.push({ name: 'updater', comment: '更新者' })
  if (!seen.has('deleted')) columns.push({ name: 'deleted', comment: '是否删除' })
  if (!seen.has('tenant_id')) columns.push({ name: 'tenant_id', comment: '租户编号' })
  if (!columns.some((column) => column.name === 'id')) {
    columns.unshift({ name: 'id', type: 'bigint', comment: '编号' })
  }

  const tableComment = entity.classComment ? ` COMMENT='${escapeSqlComment(entity.classComment)}'` : ''
  return [
    `DROP TABLE IF EXISTS \`${entity.table}\`;`,
    `CREATE TABLE \`${entity.table}\` (`,
    ...columns.map((column) => `  ${columnSql(column)},`),
    '  PRIMARY KEY (`id`)',
    `) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci${tableComment};`,
    ''
  ].join('\n')
}

const entities = sourceRoots
  .flatMap((root) => walk(path.join(repoRoot, root)))
  .map(parseEntity)
  .filter(Boolean)
  .sort((a, b) => a.table.localeCompare(b.table))

const sql = [
  '-- Generated from current mall/member/pay Java DO classes.',
  '-- Regenerate with: node scripts/generate-mall-schema.js',
  'SET NAMES utf8mb4;',
  'SET FOREIGN_KEY_CHECKS = 0;',
  '',
  ...entities.map(buildTableSql),
  'SET FOREIGN_KEY_CHECKS = 1;',
  ''
].join('\n')

fs.mkdirSync(path.dirname(outputFile), { recursive: true })
fs.writeFileSync(outputFile, sql, 'utf8')
console.log(`Generated ${entities.length} tables -> ${path.relative(repoRoot, outputFile)}`)
