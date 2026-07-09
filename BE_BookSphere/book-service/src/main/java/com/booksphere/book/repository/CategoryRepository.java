package com.booksphere.book.repository;

import com.booksphere.book.entity.Category;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {

    boolean existsByNameIgnoreCase(String name);

    boolean existsByNameIgnoreCaseAndIdNot(String name, Long id);

    Optional<Category> findByIdAndIsActiveTrue(Long id);

    List<Category> findAllByIsActiveTrue();
}
