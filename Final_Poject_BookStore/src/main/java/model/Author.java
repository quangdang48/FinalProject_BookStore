package model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import dbmodel.AuthorDB;

@Entity
@Table(name="Author")
public class Author implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int authorID;
    private String name;
    private String imageURL;
    private String description;

    @ManyToMany(fetch = FetchType.LAZY, mappedBy = "authors", cascade = {CascadeType.PERSIST, CascadeType.MERGE}) 
    private Set<Book> books = new HashSet<>();

    public Author() {}

    public Author(int id, String name) {
        this.authorID = id;
        this.name = name;
    }

    public Author(int id, String name, String imageURL) {
        this.authorID =  id;
        this.name = name;
        this.imageURL = imageURL;
    }

    public Author(String name) {
        this.name = name;
    }

    public int getId() {
        return authorID;
    }

    public void setId(int id) {
        this.authorID = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Set<Book> getBooks() {
        return AuthorDB.getInstance().getBooks(this);
    }

    public void setBooks(Set<Book> books) {
        this.books = books;
    }

    public void addBook(Book b) {
        this.books.add(b);
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getImageURL() {
        return imageURL;
    }

    public int getAuthorID() {
        return authorID;
    }

    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
}
