package util;

import java.util.ArrayList;
import java.util.List;

/**
 * Lớp tiện ích phân trang (Pagination)
 * Phân công: Hứa Hạo Danh (TV5)
 */
public class PaginationUtil<T> {

    private int currentPage;
    private int pageSize;
    private int totalRecords;
    private int totalPages;
    private int startIndex;
    private int endIndex;
    private List<T> pageItems;

    public PaginationUtil(int currentPage, int pageSize, int totalRecords) {
        if (pageSize <= 0) {
            this.pageSize = 10;
        } else {
            this.pageSize = pageSize;
        }
        this.totalRecords = Math.max(0, totalRecords);
        this.totalPages = (int) Math.ceil((double) this.totalRecords / this.pageSize);
        if (this.totalPages == 0) {
            this.totalPages = 1;
        }

        if (currentPage < 1) {
            this.currentPage = 1;
        } else if (currentPage > this.totalPages) {
            this.currentPage = this.totalPages;
        } else {
            this.currentPage = currentPage;
        }

        this.startIndex = (this.currentPage - 1) * this.pageSize;
        this.endIndex = Math.min(this.startIndex + this.pageSize, this.totalRecords);
        this.pageItems = new ArrayList<>();
    }

    /**
     * Cắt danh sách tổng thành danh sách hiển thị cho trang hiện tại
     */
    public static <E> PaginationUtil<E> paginate(List<E> allItems, int currentPage, int pageSize) {
        if (allItems == null) {
            allItems = new ArrayList<>();
        }
        PaginationUtil<E> pagination = new PaginationUtil<>(currentPage, pageSize, allItems.size());
        if (!allItems.isEmpty() && pagination.getStartIndex() < allItems.size()) {
            pagination.setPageItems(allItems.subList(pagination.getStartIndex(), pagination.getEndIndex()));
        } else {
            pagination.setPageItems(new ArrayList<>());
        }
        return pagination;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getTotalRecords() {
        return totalRecords;
    }

    public void setTotalRecords(int totalRecords) {
        this.totalRecords = totalRecords;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public int getStartIndex() {
        return startIndex;
    }

    public int getEndIndex() {
        return endIndex;
    }

    public List<T> getPageItems() {
        return pageItems;
    }

    public void setPageItems(List<T> pageItems) {
        this.pageItems = pageItems;
    }

    public boolean isHasPrevious() {
        return currentPage > 1;
    }

    public boolean isHasNext() {
        return currentPage < totalPages;
    }
}
