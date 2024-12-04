<%--
  Created by IntelliJ IDEA.
  User: vuxua
  Date: 07/11/2024
  Time: 9:57 CH
  To change this template use File | Settings | File Templates.git pull origin main
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
<%--  <script>--%>
<%--    let isNavigating = false;--%>

<%--    // Danh sách các URL cần bỏ qua--%>
<%--    const excludedUrls = [--%>
<%--      '/ms/msbook', // Đường dẫn nội bộ--%>
<%--      '/ms/mscategory',--%>
<%--      '/ms/msdashboard',--%>
<%--      '/ms/msorder',--%>
<%--      '/ms/mscustomer',--%>
<%--      '/ms/mscampaign',--%>
<%--      '/ms/msreview',--%>
<%--      '/ms/msauthor',--%>
<%--      '/ms/mspublisher',--%>
<%--      '/ms/ms_staff'--%>
<%--    ];--%>

<%--    // Lắng nghe sự kiện chuyển hướng nội bộ--%>
<%--    document.addEventListener('click', (event) => {--%>
<%--      const target = event.target.closest('a'); // Phát hiện thẻ <a> gần nhất--%>
<%--      if (target && target.href) {--%>
<%--        const targetUrl = new URL(target.href, window.location.origin);--%>
<%--        const relativePath = targetUrl.pathname; // Lấy đường dẫn tương đối--%>

<%--        // Kiểm tra nếu URL thuộc danh sách được loại trừ--%>
<%--        if (excludedUrls.includes(relativePath) || excludedUrls.includes(target.href)) {--%>
<%--          isNavigating = true; // Đánh dấu là chuyển hướng hợp lệ--%>
<%--        }--%>
<%--      }--%>
<%--    });--%>

<%--    // Xử lý sự kiện trước khi rời khỏi trang--%>
<%--    window.addEventListener('beforeunload', (event) => {--%>
<%--      if (!isNavigating) {--%>
<%--        // Chỉ xử lý khi không phải các URL được loại trừ--%>
<%--        navigator.sendBeacon('/signout/manage/admin');--%>
<%--        console.log('Logout request sent as browser is being closed or navigated away');--%>
<%--      }--%>
<%--    });--%>
<%--  </script>--%>
  <title>Naoki - Management System</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <%--    Poppins--%>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
  <%--    Swiper--%>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@splidejs/splide@4.1.4/dist/css/splide.min.css" integrity="sha256-5uKiXEwbaQh9cgd2/5Vp6WmMnsUr3VZZw0a8rKnOKNU=" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/@splidejs/splide@4.1.4/dist/js/splide.min.js" integrity="sha256-FZsW7H2V5X9TGinSjjwYJ419Xka27I8XPDmWryGlWtw=" crossorigin="anonymous"></script>
  <%--    Bootstrap--%>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
  <%-- Favicon --%>
  <link rel="icon" href="${pageContext.request.contextPath}/assets/images/logos/square-logo.png" type="image/x-icon">
  <%-- Fontawesome --%>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

  <%--Custom CSS--%>
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/styles/main.css">
</head>
<body>
<!-- Header -->
<jsp:include page="sidebar.jsp">
  <jsp:param name="currentTab" value="review" />
</jsp:include>
<!-- end Header -->

<main class="content" style="margin-left: 250px; padding: 20px;">
  <div class="container fw-medium">
    <div class="row mb-3">
      <div class="col-md-4 d-flex flex-colum">
        <input type="text" class="form-control fw-medium" id="searchBox" placeholder="Search review...">
      </div>
<%--      <div class="col-md-8 d-flex justify-content-end">--%>
<%--        <button class="primary-btn" data-bs-toggle="modal" data-bs-target="#addCategoryModal">Add Review</button>--%>
<%--      </div>--%>
    </div>
    <div class="table-responsive border border-2 p-2" style="max-height: 75%; overflow: auto;">
      <table class="table table-bordered" style="min-width: 1000px;">
        <thead>
        <tr>
          <th></th>
          <th>ID</th>
          <th>Khách hàng</th>
          <th>Sách</th>
          <th>Nhận xét</th>
          <th>Đánh giá</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="review" items="${sessionScope.reviews}">
          <tr class="fw-medium">
            <td class="d-flex">
<%--              <button class="btn btn-warning btn-sm me-2" data-bs-toggle="modal" data-bs-target="#editCategoryModal"--%>
<%--                      onclick="editCategory(${review.getReviewID()},${review.getCustomer().getId()},${review.getBook().getId()}, '${review.getDescription()}', '${review.getRate()}')">--%>
<%--                <i class="fas fa-edit"></i>--%>
<%--              </button>--%>
              <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/ms/msreview" class="mb-0">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="deleteId" value="${review.getReviewID()}"/>
                <button type="submit" class="btn btn-danger btn-sm">
                  <i class="fas fa-trash"></i>
                </button>
              </form>
            </td>
            <td>${fn:escapeXml(review.getReviewID())}</td>
            <td>${fn:escapeXml(review.getCustomer().getFullName())}</td>
            <td>${review.getBook().getTitle()}</td>
            <td>${review.getDescription()}</td>
            <td>${review.getRate()}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</main>

<!-- Add Category Modal -->
<%--<div class="modal fade fw-medium" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">--%>
<%--  <div class="modal-dialog">--%>
<%--    <div class="modal-content">--%>
<%--      <form action="ms_campaign" method="post">--%>
<%--        <input type="hidden" name="csrf" value="${_csrf.token}"/>--%>
<%--        <input type="hidden" name="action" value="add"/>--%>
<%--        <div class="modal-header">--%>
<%--          <h5 class="modal-title fw-semibold" id="addCategoryModalLabel">Add Campaign</h5>--%>
<%--          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>--%>
<%--        </div>--%>
<%--        <div class="modal-body">--%>
<%--          <div class="mb-3">--%>
<%--            <label for="customerAccount" class="form-label">Chiến dịch</label>--%>
<%--            <input type="text" class="form-control" id="customerAccount" name="campaign" required>--%>
<%--          </div>--%>
<%--          <div class="mb-3">--%>
<%--            <label for="customerPassword" class="form-label">Ngày bắt đầu</label>--%>
<%--            <input type="date" class="form-control" id="customerPassword" name="start" required>--%>
<%--          </div>--%>
<%--          <div class="mb-3">--%>
<%--            <label for="customerFullName" class="form-label">Ngày kết thúc</label>--%>
<%--            <input type="date" class="form-control" id="customerFullName" name="end" required>--%>
<%--          </div>--%>
<%--          <div class="mb-3">--%>
<%--            <label for="customerAge" class="form-label">Giảm giá</label>--%>
<%--            <input type="number" class="form-control" id="customerAge" name="discount" required>--%>
<%--          </div>--%>
<%--        </div>--%>
<%--        <div class="modal-footer">--%>
<%--          <button type="button" class="secondary-btn" data-bs-dismiss="modal">Close</button>--%>
<%--          <button type="submit" class="primary-btn">Save</button>--%>
<%--        </div>--%>
<%--      </form>--%>
<%--    </div>--%>
<%--  </div>--%>
<%--</div>--%>

<!-- Edit Category Modal -->
<div class="modal fade fw-medium" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="${pageContext.request.contextPath}/ms/msreview" method="post">
        <%-- Validate CSRF token --%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="action" value="edit"/>
        <div class="modal-header">
          <h5 class="modal-title fw-semibold" id="editCategoryModalLabel">Edit Review</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="editReviewId" name="reviewId"/>
          <input type="hidden" id="editCustomerId" name="customerId"/>
          <input type="hidden" id="editBookId" name="bookId"/>
          <div class="mb-3">
            <label for="editReviewRate" class="form-label">Đánh giá</label>
            <input type="text" class="form-control" id="editReviewRate" name="rate" required>
          </div>
          <div class="mb-3">
            <label for="editReviewDes" class="form-label">Nhận xét</label>
            <textarea class="form-control" id="editReviewDes" name="description" required rows="5"></textarea>
          </div>

        </div>
        <div class="modal-footer">
          <button type="button" class="secondary-btn" data-bs-dismiss="modal">Close</button>
          <button type="submit" class="primary-btn">Save</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  function editCategory(id, cus_id, book_id, description, rate) {
    document.getElementById('editReviewId').value = id;
    document.getElementById('editCustomerId').value = cus_id;
    document.getElementById('editBookId').value = book_id;
    document.getElementById('editReviewRate').value = rate;
    document.getElementById('editReviewDes').value = description;
  }

  function deleteCategory() {
    if (confirm('Are you sure you want to delete this category?')) {
      document.getElementById("deleteForm").submit();
    }
  }

  document.getElementById('searchBox').addEventListener('input', function() {
    let filter = this.value.toUpperCase();
    let rows = document.querySelector("tbody").rows;
    for (let i = 0; i < rows.length; i++) {
      let firstCol = rows[i].cells[2].textContent.toUpperCase();
      let secondCol = rows[i].cells[3].textContent.toUpperCase();
      if (firstCol.indexOf(filter) > -1 || secondCol.indexOf(filter) > -1) {
        rows[i].style.display = "";
      } else {
        rows[i].style.display = "none";
      }
    }
  });
</script>
</body>
</html>
