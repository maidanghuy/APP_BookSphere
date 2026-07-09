package com.booksphere.book.repository;

import com.booksphere.book.entity.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BookRepository extends JpaRepository<Book, Long> {

    boolean existsByIsbn(String isbn);

    boolean existsByIsbnAndIdNot(String isbn, Long id);

    boolean existsByCategoryIdAndIsActiveTrue(Long categoryId);

    @Query("""
        SELECT b FROM Book b
        JOIN FETCH b.category c
        WHERE b.id = :id
          AND b.isActive = true
          AND c.isActive = true
        """)
    java.util.Optional<Book> findActiveBookWithActiveCategory(@Param("id") Long id);

    @Query("""
        SELECT b FROM Book b
        JOIN b.category c
        WHERE b.isActive = true
          AND c.isActive = true
          AND (:keyword IS NULL OR :keyword = '' OR
               LOWER(b.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
               LOWER(b.author) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
               LOWER(b.isbn) LIKE LOWER(CONCAT('%', :keyword, '%')))
          AND (:categoryId IS NULL OR c.id = :categoryId)
        """)
    Page<Book> searchActiveBooks(
            @Param("keyword") String keyword,
            @Param("categoryId") Long categoryId,
            Pageable pageable
    );

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("""
        UPDATE Book b
        SET b.availableQuantity = b.availableQuantity - :quantity
        WHERE b.id = :bookId
          AND b.isActive = true
          AND b.availableQuantity >= :quantity
        """)
    int decreaseStock(@Param("bookId") Long bookId, @Param("quantity") Integer quantity);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("""
        UPDATE Book b
        SET b.availableQuantity = b.availableQuantity + :quantity
        WHERE b.id = :bookId
          AND b.isActive = true
          AND (b.availableQuantity + :quantity) <= b.totalQuantity
        """)
    int increaseStock(@Param("bookId") Long bookId, @Param("quantity") Integer quantity);
}
