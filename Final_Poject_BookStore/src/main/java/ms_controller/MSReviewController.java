package ms_controller;

import dbmodel.BookDB;
import dbmodel.CustomerDB;
import dbmodel.DiscountCampaignDB;
import dbmodel.ReviewDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import model.Customer;
import model.DiscountCampaign;
import model.Review;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/ms_review")
public class MSReviewController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Review> reviews = ReviewDB.getInstance().selectAll();

        HttpSession session = req.getSession();
        session.setAttribute("reviews", reviews);

        req.getServletContext().getRequestDispatcher("/Management-System/ms-review.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if(action != null) {
            switch (action) {
                case "edit":
                {
                    Book book = BookDB.getInstance().selectByID(Integer.parseInt(req.getParameter("bookId")));
                    Customer customer = CustomerDB.getInstance().selectByID(Integer.parseInt(req.getParameter("customerId")));
                    ReviewDB.getInstance().update(new Review(Integer.parseInt(req.getParameter("reviewId")), Integer.parseInt(req.getParameter("rate")), req.getParameter("description"), customer, book));
                    break;
                }
                case "delete":
                {
                    System.out.println(req.getParameter("deleteId"));
                    ReviewDB.getInstance().delete(Integer.parseInt(req.getParameter("deleteId")), Review.class);
                    break;
                }
            }
        }

        resp.sendRedirect(getServletContext().getContextPath() + "/ms_review");

    }
}
