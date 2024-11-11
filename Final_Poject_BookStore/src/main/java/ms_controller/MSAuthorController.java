package ms_controller;

import dbmodel.AuthorDB;
import dbmodel.BookDB;
import dbmodel.CustomerDB;
import dbmodel.ReviewDB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Author;
import model.Book;
import model.Customer;
import model.Review;

import java.io.IOException;
import java.util.List;

@WebServlet("/ms_author")
public class MSAuthorController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Author> authors = AuthorDB.getInstance().selectAll();

        HttpSession session = req.getSession();
        session.setAttribute("authors", authors);

        req.getServletContext().getRequestDispatcher("/Management-System/ms-author.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if(action != null) {
            switch (action) {
                case "edit":
                {
                    AuthorDB.getInstance().update(new Author(Integer.parseInt(req.getParameter("author_id")), req.getParameter("author"), req.getParameter("avatar")));
                    break;
                }
                case "add":{
                    AuthorDB.getInstance().insert(new Author(req.getParameter("author")));
                    break;
                }
                case "delete":
                {
                    System.out.println(req.getParameter("deleteId"));
                    AuthorDB.getInstance().delete(Integer.parseInt(req.getParameter("deleteId")), Author.class);
                    break;
                }
            }
        }

        resp.sendRedirect(getServletContext().getContextPath() + "/ms_author");

    }
}
