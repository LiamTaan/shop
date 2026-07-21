import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const SOURCE_URL = 'https://fakestoreapi.com/products';
const TENANT_ID = 1;
const CATEGORY_ROOT_ID = 11000;
const CATEGORY_ID_START = 11001;
const BRAND_ID_START = 12001;
const SPU_ID_START = 20000;
const SKU_ID_START = 30000;
const USD_TO_CNY = 7.2;

const CATEGORY_NAMES = {
  "men's clothing": '男装服饰',
  "women's clothing": '女装服饰',
  jewelery: '珠宝配饰',
  electronics: '数码家电',
};

const BRAND_BY_PRODUCT_ID = {
  1: 'Fjallraven',
  5: 'John Hardy',
  9: 'WD',
  10: 'SanDisk',
  11: 'Silicon Power',
  12: 'WD',
  13: 'Acer',
  14: 'Samsung',
  15: 'BIYLACLESEN',
  16: 'Lock and Love',
};

const DEFAULT_BRAND = '商城严选';
const OUTPUT_PATH = resolve(
  dirname(fileURLToPath(import.meta.url)),
  '../../sql/mysql/03-mall-fakestore-seed.sql',
);

function sqlString(value) {
  if (value === null || value === undefined) {
    return 'NULL';
  }
  return `'${String(value).replaceAll("'", "''")}'`;
}

function htmlEscape(value) {
  return String(value)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

function toCents(usdPrice) {
  return Math.max(1, Math.round(Number(usdPrice) * USD_TO_CNY * 100));
}

function upsert(table, columns, rows, updateColumns) {
  const values = rows
    .map((row) => `  (${columns.map((column) => row[column]).join(', ')})`)
    .join(',\n');
  const updates = updateColumns
    .map((column) => `  \`${column}\` = VALUES(\`${column}\`)`)
    .join(',\n');
  return `INSERT INTO \`${table}\`\n  (${columns.map((column) => `\`${column}\``).join(', ')})\nVALUES\n${values}\nON DUPLICATE KEY UPDATE\n${updates};`;
}

async function fetchProducts() {
  const response = await fetch(SOURCE_URL, {
    headers: { Accept: 'application/json' },
    signal: AbortSignal.timeout(30_000),
  });
  if (!response.ok) {
    throw new Error(`Fake Store API 请求失败：HTTP ${response.status}`);
  }
  const products = await response.json();
  if (!Array.isArray(products) || products.length === 0) {
    throw new Error('Fake Store API 未返回商品列表');
  }
  return products.sort((left, right) => left.id - right.id);
}

function buildSql(products) {
  const categoryKeys = [...new Set(products.map((product) => product.category))].sort();
  const categoryIdByKey = new Map(
    categoryKeys.map((category, index) => [category, CATEGORY_ID_START + index]),
  );

  const brands = [...new Set(products.map((product) => BRAND_BY_PRODUCT_ID[product.id] ?? DEFAULT_BRAND))].sort();
  const brandIdByName = new Map(brands.map((brand, index) => [brand, BRAND_ID_START + index]));

  const firstProductByCategory = new Map();
  const firstProductByBrand = new Map();
  for (const product of products) {
    const brand = BRAND_BY_PRODUCT_ID[product.id] ?? DEFAULT_BRAND;
    firstProductByCategory.set(product.category, firstProductByCategory.get(product.category) ?? product);
    firstProductByBrand.set(brand, firstProductByBrand.get(brand) ?? product);
  }

  const categoryRows = [
    {
      id: CATEGORY_ROOT_ID,
      parent_id: 0,
      name: sqlString('演示商品库'),
      pic_url: sqlString(products[0].image),
      sort: 200,
      status: 0,
      creator: sqlString('fakestore-seed'),
      updater: sqlString('fakestore-seed'),
      deleted: "b'0'",
      tenant_id: TENANT_ID,
    },
    ...categoryKeys.map((category, index) => ({
      id: categoryIdByKey.get(category),
      parent_id: CATEGORY_ROOT_ID,
      name: sqlString(CATEGORY_NAMES[category] ?? category),
      pic_url: sqlString(firstProductByCategory.get(category).image),
      sort: 190 - index * 10,
      status: 0,
      creator: sqlString('fakestore-seed'),
      updater: sqlString('fakestore-seed'),
      deleted: "b'0'",
      tenant_id: TENANT_ID,
    })),
  ];

  const brandRows = brands.map((brand, index) => ({
    id: brandIdByName.get(brand),
    name: sqlString(brand),
    pic_url: sqlString(firstProductByBrand.get(brand).image),
    sort: 200 - index,
    description: sqlString(`${brand} 演示品牌，数据来自 Fake Store API，仅用于本地开发与界面联调。`),
    status: 0,
    creator: sqlString('fakestore-seed'),
    updater: sqlString('fakestore-seed'),
    deleted: "b'0'",
    tenant_id: TENANT_ID,
  }));

  const spuRows = products.map((product, index) => {
    const price = toCents(product.price);
    const marketPrice = Math.round(price * 1.2);
    const costPrice = Math.round(price * 0.62);
    const ratingCount = Number(product.rating?.count ?? 0);
    const rating = Number(product.rating?.rate ?? 0);
    const categoryName = CATEGORY_NAMES[product.category] ?? product.category;
    const description = [
      `<p>${htmlEscape(product.description)}</p>`,
      `<p><strong>商品分类：</strong>${htmlEscape(categoryName)}</p>`,
      `<p><strong>演示评分：</strong>${rating.toFixed(1)} / 5（${ratingCount} 条样本）</p>`,
      '<p>数据来源：Fake Store API 公开演示数据，仅用于本地开发、页面展示与接口联调，不代表真实在售商品。</p>',
    ].join('');
    return {
      id: SPU_ID_START + product.id,
      name: sqlString(product.title.trim()),
      keyword: sqlString(`${categoryName},演示商品,Fake Store API`),
      introduction: sqlString(`${categoryName}演示商品，评分 ${rating.toFixed(1)}，仅用于商城功能联调。`),
      description: sqlString(description),
      category_id: categoryIdByKey.get(product.category),
      brand_id: brandIdByName.get(BRAND_BY_PRODUCT_ID[product.id] ?? DEFAULT_BRAND),
      pic_url: sqlString(product.image),
      slider_pic_urls: sqlString(JSON.stringify([product.image])),
      sort: 200 - index,
      status: 1,
      spec_type: "b'0'",
      price,
      market_price: marketPrice,
      cost_price: costPrice,
      stock: Math.max(20, Math.min(500, ratingCount)),
      delivery_types: sqlString('1'),
      delivery_template_id: 'NULL',
      give_integral: Math.floor(price / 100),
      sub_commission_type: "b'0'",
      sales_count: Math.floor(ratingCount * 0.4),
      virtual_sales_count: ratingCount,
      browse_count: ratingCount * 5,
      creator: sqlString('fakestore-seed'),
      updater: sqlString('fakestore-seed'),
      deleted: "b'0'",
      tenant_id: TENANT_ID,
    };
  });

  const skuRows = products.map((product) => {
    const price = toCents(product.price);
    const ratingCount = Number(product.rating?.count ?? 0);
    return {
      id: SKU_ID_START + product.id,
      spu_id: SPU_ID_START + product.id,
      properties: sqlString('[]'),
      price,
      market_price: Math.round(price * 1.2),
      cost_price: Math.round(price * 0.62),
      bar_code: sqlString(`FAKESTORE-${String(product.id).padStart(4, '0')}`),
      pic_url: sqlString(product.image),
      stock: Math.max(20, Math.min(500, ratingCount)),
      weight: 0.5,
      volume: 0.01,
      first_brokerage_price: 0,
      second_brokerage_price: 0,
      sales_count: Math.floor(ratingCount * 0.4),
      creator: sqlString('fakestore-seed'),
      updater: sqlString('fakestore-seed'),
      deleted: "b'0'",
      tenant_id: TENANT_ID,
    };
  });

  const commonColumns = ['id', 'parent_id', 'name', 'pic_url', 'sort', 'status', 'creator', 'updater', 'deleted', 'tenant_id'];
  const brandColumns = ['id', 'name', 'pic_url', 'sort', 'description', 'status', 'creator', 'updater', 'deleted', 'tenant_id'];
  const spuColumns = ['id', 'name', 'keyword', 'introduction', 'description', 'category_id', 'brand_id', 'pic_url', 'slider_pic_urls', 'sort', 'status', 'spec_type', 'price', 'market_price', 'cost_price', 'stock', 'delivery_types', 'delivery_template_id', 'give_integral', 'sub_commission_type', 'sales_count', 'virtual_sales_count', 'browse_count', 'creator', 'updater', 'deleted', 'tenant_id'];
  const skuColumns = ['id', 'spu_id', 'properties', 'price', 'market_price', 'cost_price', 'bar_code', 'pic_url', 'stock', 'weight', 'volume', 'first_brokerage_price', 'second_brokerage_price', 'sales_count', 'creator', 'updater', 'deleted', 'tenant_id'];
  const featuredSpuIds = products.slice(0, 8).map((product) => SPU_ID_START + product.id);

  return [
    '-- Fake Store API demo catalog seed for tenant 1.',
    '-- Source: https://fakestoreapi.com/products',
    '-- Prices are converted with 1 USD = 7.2 CNY for local UI testing only.',
    '-- Import through a UTF-8 file path; do not pipe non-ASCII SQL through a Windows shell.',
    '',
    'SET NAMES utf8mb4;',
    'START TRANSACTION;',
    '',
    upsert('product_category', commonColumns, categoryRows, commonColumns.filter((column) => column !== 'id')),
    '',
    upsert('product_brand', brandColumns, brandRows, brandColumns.filter((column) => column !== 'id')),
    '',
    upsert('product_spu', spuColumns, spuRows, spuColumns.filter((column) => column !== 'id')),
    '',
    upsert('product_sku', skuColumns, skuRows, skuColumns.filter((column) => column !== 'id')),
    '',
    'UPDATE `promotion_diy_page`',
    `SET \`property\` = JSON_SET(\`property\`, '$.components[4].property.spuIds', JSON_ARRAY(${featuredSpuIds.join(', ')})),`,
    "    `updater` = 'fakestore-seed'",
    'WHERE `id` = 100101',
    `  AND \`tenant_id\` = ${TENANT_ID}`,
    "  AND `deleted` = b'0'",
    '  AND JSON_VALID(`property`) = 1',
    "  AND JSON_UNQUOTE(JSON_EXTRACT(`property`, '$.components[4].id')) = 'ProductList';",
    '',
    'COMMIT;',
    '',
  ].join('\n');
}

const products = await fetchProducts();
const sql = buildSql(products);
await mkdir(dirname(OUTPUT_PATH), { recursive: true });
await writeFile(OUTPUT_PATH, sql, { encoding: 'utf8' });
console.log(`已生成 ${products.length} 条商品：${OUTPUT_PATH}`);
