package eibooks.dto;

public class BookDTO {

	private int book_seq;
    private String title;
    private String author;
    private String publisher;
    private String category;
    private String imageFile;
    private String description;
    private int price;
    private int stock;
    private String isbn10;
    private String isbn13;
    private String pubDate;
    private int viewCount;

    public BookDTO() {
        super();
    }

    public BookDTO(String title, String author, String publisher, String category, String imageFile,
                   String description, int price, int stock, String isbn10, String isbn13, String pubDate) {
        super();
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.category = category;
        this.imageFile = imageFile;
        this.description = description;
        this.price = price;
        this.stock = stock;
        this.isbn10 = isbn10;
        this.isbn13 = isbn13;
        this.pubDate = pubDate;
    }
    
    public BookDTO(String title, String author, String publisher, String category, String imageFile,
    		String description, int price, String isbn10, String isbn13, String pubDate) {
    	super();
    	this.title = title;
    	this.author = author;
    	this.publisher = publisher;
    	this.category = category;
    	this.imageFile = imageFile;
    	this.description = description;
    	this.price = price;
    	this.isbn10 = isbn10;
    	this.isbn13 = isbn13;
    	this.pubDate = pubDate;
    }
    
    public BookDTO(int book_seq, String title, String author, String publisher, String category, String imageFile,
			String description, int price, int stock, String isbn10, String isbn13, String pubDate) {
		super();
		this.book_seq = book_seq;
		this.title = title;
		this.author = author;
		this.publisher = publisher;
		this.category = category;
		this.imageFile = imageFile;
		this.description = description;
		this.price = price;
		this.stock = stock;
		this.isbn10 = isbn10;
		this.isbn13 = isbn13;
		this.pubDate = pubDate;
	}
    
    

	public int getBook_seq() {
        return book_seq;
    }

    public void setBook_seq(int book_seq) {
        this.book_seq = book_seq;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getImageFile() {
        return imageFile;
    }

    public void setImageFile(String imageFile) {
        this.imageFile = imageFile;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getIsbn10() {
        return isbn10;
    }

    public void setIsbn10(String isbn10) {
        this.isbn10 = isbn10;
    }

    public String getIsbn13() {
        return isbn13;
    }

    public void setIsbn13(String isbn13) {
        this.isbn13 = isbn13;
    }

    public String getPubDate() {
        return pubDate;
    }

    public void setPubDate(String pubDate) {
        this.pubDate = pubDate;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	@Override
	public String toString() {
		return "BookDTO [book_seq=" + book_seq + ", title=" + title + ", author=" + author + ", publisher=" + publisher
				+ ", category=" + category + ", imageFile=" + imageFile + ", description=" + description + ", price="
				+ price + ", stock=" + stock + ", isbn10=" + isbn10 + ", isbn13=" + isbn13 + ", pubDate=" + pubDate
				+ ", viewCount=" + viewCount + "]";
	}
	
}
