package everytable.menu.vo;

public class MenuVO {
    private long menu_no;
    private String menu_name;
    private long price;
    private String description;
    private String image_url;

    // Getter & Setter
    public long getMenu_no() { return menu_no; }
    public void setMenu_no(long menu_no) { this.menu_no = menu_no; }
    public String getMenu_name() { return menu_name; }
    public void setMenu_name(String menu_name) { this.menu_name = menu_name; }
    public long getPrice() { return price; }
    public void setPrice(long price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImage_url() { return image_url; }
    public void setImage_url(String image_url) { this.image_url = image_url; }
}