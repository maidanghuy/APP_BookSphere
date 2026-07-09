package com.booksphere.book.cache;

import com.booksphere.book.dto.response.CategoryResponse;
import java.util.ArrayList;
import java.util.List;

public class CategoryListCacheValue {

    private List<CategoryResponse> categories = new ArrayList<>();

    public List<CategoryResponse> getCategories() {
        return categories;
    }

    public void setCategories(List<CategoryResponse> categories) {
        this.categories = categories;
    }
}
