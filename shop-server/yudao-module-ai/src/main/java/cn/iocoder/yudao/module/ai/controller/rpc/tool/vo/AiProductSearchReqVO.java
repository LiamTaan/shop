package cn.iocoder.yudao.module.ai.controller.rpc.tool.vo;

import lombok.Data;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import cn.hutool.core.util.StrUtil;

@Data
public class AiProductSearchReqVO {

    /**
     * 关键词；可与筛选条件组合。允许为空（仅按分类/价格等筛选）。
     */
    private String keyword;

    private Long categoryId;

    /**
     * 分类名称（模糊匹配，解析出 categoryId 后再查商品）。
     */
    private String categoryName;

    /**
     * 最低价，单位：分。
     */
    @Min(value = 0, message = "minPrice must be >= 0")
    private Integer minPrice;

    /**
     * 最高价，单位：分。
     */
    @Min(value = 0, message = "maxPrice must be >= 0")
    private Integer maxPrice;

    /**
     * 是否仅返回有货（stock > 0）。默认 true。
     */
    private Boolean inStock = true;

    /**
     * 排序字段：price / salesCount
     */
    private String sortField;

    /**
     * true=升序，false=降序
     */
    private Boolean sortAsc;

    @Min(value = 1, message = "Limit must be at least 1")
    @Max(value = 10, message = "Limit cannot exceed 10")
    private Integer limit = 5;

    @AssertTrue(message = "maxPrice must be >= minPrice")
    public boolean isPriceRangeValid() {
        if (minPrice == null || maxPrice == null) {
            return true;
        }
        return maxPrice >= minPrice;
    }

    @AssertTrue(message = "keyword or at least one filter is required")
    public boolean isQueryValid() {
        return StrUtil.isNotBlank(keyword)
                || categoryId != null
                || StrUtil.isNotBlank(categoryName)
                || minPrice != null
                || maxPrice != null;
    }

}