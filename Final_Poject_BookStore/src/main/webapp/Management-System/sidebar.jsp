<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // Map tabs to their titles, icons, and URLs
  Map<String, String[]> tabs = new LinkedHashMap<>();
  tabs.put("dashboard", new String[]{"Tổng quan", "fa-gauge", "#"});
  tabs.put("book", new String[]{"Sách", "fa-book", "/msbook"});
  tabs.put("category", new String[]{"Danh mục sách", "fa-layer-group", "/mscategory"});
  tabs.put("order", new String[]{"Đơn hàng", "fa-box", "#"});
  tabs.put("bill", new String[]{"Hóa đơn", "fa-receipt", "#"});
  tabs.put("customer", new String[]{"Khách hàng", "fa-user", "#"});
  tabs.put("campaign", new String[]{"Chiến dịch", "fa-tags", "#"});
  tabs.put("review", new String[]{"Đánh giá", "fa-message", "#"});
  tabs.put("author", new String[]{"Tác giả", "fa-square-pen", "#"});
  tabs.put("publisher", new String[]{"Nhà xuất bản", "fa-print", "#"});
  tabs.put("staff", new String[]{"Nhân viên", "fa-clipboard-user", "#"});
  tabs.put("signout", new String[]{"Đăng xuất", "fa-right-from-bracket", "#"});

  String currentTab = request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "dashboard";
  String tabTitle = tabs.containsKey(currentTab) ? tabs.get(currentTab)[0] : "Tổng quan";
%>

<aside class="sidebar bg-dark text-light d-flex flex-column p-3" style="width: 250px; height: 100vh; position: fixed;">
  <div class="brand mb-3 text-center">
    <img src="${pageContext.request.contextPath}/assets/images/logos/logo-2.png" alt="logo" style="height: 40px;">
  </div>
  <ul class="nav flex-column fs-5">
    <% for (Map.Entry<String, String[]> entry : tabs.entrySet()) { %>
    <li class="nav-item">
      <a class="nav-link text-light <%= currentTab.equals(entry.getKey()) ? "active" : "" %>" href="<%= entry.getValue()[2] %>">
        <i class="fa-solid <%= entry.getValue()[1] %> me-2"></i> <%= entry.getValue()[0] %>
      </a>
    </li>
    <% } %>
  </ul>
</aside>

<nav class="topbar bg-light px-4 shadow-sm" style="margin-left: 250px; height: 60px; display: flex; align-items: center; justify-content: space-between;">
  <span class="fw-bold fs-4"><%= tabTitle %></span>
  <span class="fw-semibold fs-5">Administrator <i class="fa-solid fa-user ms-2"></i></span>
</nav>
