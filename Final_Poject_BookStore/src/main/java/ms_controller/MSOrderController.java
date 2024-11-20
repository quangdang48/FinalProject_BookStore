package ms_controller;

import dbmodel.BillDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Bill;
import model.StatusOrder;
import model.StatusPayment;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "MSOrderController", urlPatterns = {"/msorder"})
public class MSOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null && (action.equalsIgnoreCase("updateStatus") || action.equalsIgnoreCase("cancelOrder") || action.equalsIgnoreCase("deleteOrder"))) {
            if (action.equalsIgnoreCase("deleteOrder")) {
                handleDeleteOrder(request, response);
            } else {
                handleOrderStatusUpdate(request, response);
            }
        } else {
            handleBillRequest(request, response);
        }
    }

    /*
     * Handle bill request
     * - Get bill ID from request
     * - If the bill ID is not empty, get the bill from the database
     * - Set the bill as an attribute of the request
     * - Forward the request to the order detail page
     * - If the bill ID is empty, process the request
     */
    private void handleBillRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billIdParam = request.getParameter("billId");
        if (billIdParam != null && !billIdParam.isEmpty()) {
            try {
                int billId = Integer.parseInt(billIdParam);
                Bill bill = BillDB.getInstance().selectByID(billId);
                
                request.setAttribute("bill", bill);
                request.getRequestDispatcher("/Management-System/ms-orderdetail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID");
            }
        } else {
            processRequest(request, response);
        }
    }

    /*
     * Process request
     * - Get all bills except storing status
     * - Sort by status order and bill ID (descending)
     * - Set the bills, status order, and status payment as attributes of the request
     * - Forward the request to the order page
     */
    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get all bills except storing status
        // Sort by status order and bill ID (descending)
        List<Bill> allBill = BillDB.getInstance().selectAll()
                .stream()
                .filter(b -> !("Storing".equals(b.getStatusOrder().toString())))
                .sorted((b1, b2) -> {
                    int statusComparison = compareStatusOrder(b1.getStatusOrder(), b2.getStatusOrder());
                    if (statusComparison != 0) {
                        return statusComparison;
                    }
                    return Integer.compare(b2.getId(), b1.getId());
                })
                .collect(Collectors.toList());
        List<StatusOrder> statusOrders = Arrays.stream(StatusOrder.values())
                .filter(status -> status != StatusOrder.Storing)
                .collect(Collectors.toList());
        StatusPayment[] statusPayments = StatusPayment.values();

        request.setAttribute("bills", allBill);
        request.setAttribute("StatusOrder", statusOrders);
        request.setAttribute("StatusPayment", statusPayments);
        request.getRequestDispatcher("/Management-System/ms-order.jsp").forward(request, response);
    }

    // Compare the order of status in the enum
    private int compareStatusOrder(StatusOrder s1, StatusOrder s2) {
        List<StatusOrder> order = Arrays.asList(
                StatusOrder.Processing,
                StatusOrder.Packing,
                StatusOrder.Delivering,
                StatusOrder.Delivered,
                StatusOrder.Completed,
                StatusOrder.Cancelled
        );
        return Integer.compare(order.indexOf(s1), order.indexOf(s2));
    }

    /* 
        Handle order status update request
        - Get bill ID from request
        - Get the bill from the database
        - Get the action from the request
        - Get the current status of the bill
        - Get the next status based on the current status
        - Update the status of the bill
        - If the next status is Delivered, update the payment status and delivery date
        - Update the bill in the database
        - If the update is successful, handle the bill request
        - If the update is failed, return an internal server error
     */
    private void handleOrderStatusUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billIdParam = request.getParameter("billId");
        if (billIdParam != null && !billIdParam.isEmpty()) {
            try {
                int billId = Integer.parseInt(billIdParam);
                Bill bill = BillDB.getInstance().selectByID(billId);
                if (bill != null) {
                    String action = request.getParameter("action");
                    StatusOrder currentStatus = bill.getStatusOrder();
                    StatusOrder nextStatus = null;

                    if (action.equalsIgnoreCase("cancelOrder")) {
                        StatusPayment currentPaymentStatus = bill.getStatusPayment();
                        if ((currentStatus == StatusOrder.Processing || currentStatus == StatusOrder.Packing || currentStatus == StatusOrder.Delivering) 
                                && currentPaymentStatus == StatusPayment.Unpaid) {
                            nextStatus = StatusOrder.Cancelled;
                        } else {
                            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order cannot be cancelled");
                            return;
                        }
                    } else {
                        nextStatus = getNextStatus(currentStatus);
                    }

                    if (nextStatus != null) {
                        bill.setStatusOrder(nextStatus);
                        if (nextStatus == StatusOrder.Delivered) {
                            bill.setStatusPayment(StatusPayment.Paid);
                            bill.setDeliveryDate(LocalDate.now());
                        }
                        boolean isUpdated = BillDB.getInstance().update(bill);
                        if (isUpdated) {
                            handleBillRequest(request, response);
                        } else {
                            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update order status");
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order status transition");
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bill ID is required");
    }
}

    // Handle delete order request
    private void handleDeleteOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String billIdParam = request.getParameter("billId");
        if (billIdParam != null && !billIdParam.isEmpty()) {
            try {
                int billId = Integer.parseInt(billIdParam);
                Bill bill = BillDB.getInstance().selectByID(billId);
                if (bill != null) {
                    if (bill.getStatusOrder() == StatusOrder.Cancelled) {
                        boolean isDeleted = BillDB.getInstance().delete(bill.getId(), Bill.class);
                        if (isDeleted) {
                            response.sendRedirect(request.getContextPath() + "/msorder");
                        } else {
                            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete order");
                        }
                    } else {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Only cancelled orders can be deleted");
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid bill ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Bill ID is required");
        }
    }

    // Get the next status based on the current status
    private StatusOrder getNextStatus(StatusOrder currentStatus) {
        switch (currentStatus) {
            case Processing:
                return StatusOrder.Packing;
            case Packing:
                return StatusOrder.Delivering;
            case Delivering:
                return StatusOrder.Delivered;
            case Delivered:
                return StatusOrder.Completed;
            case Cancelled:
            case Completed:
                return null; // No transition from Cancelled or Completed
            default:
                return null;
        }
    }
}
