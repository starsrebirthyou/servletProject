package everytable.menu.vo;
import java.util.Date;

public class MenuVO {
    private long menu_no;
    private long store_id;
    private String menu_name;
    private int price;
    private String description;
    private String image_url;
    private int is_active;
    private Date created_date;
    private int quantity;

    public long getMenu_no() { return menu_no; }
    public void setMenu_no(long menu_no) { this.menu_no = menu_no; }
    public long getStore_id() { return store_id; }
    public void setStore_id(long store_id) { this.store_id = store_id; }
    public String getMenu_name() { return menu_name; }
    public void setMenu_name(String menu_name) { this.menu_name = menu_name; }
    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; } // ✅ 수정
    public String getImage_url() { return image_url; }
    public void setImage_url(String image_url) { this.image_url = image_url; }
    public int getIs_active() { return is_active; }
    public void setIs_active(int is_active) { this.is_active = is_active; }
    public Date getCreated_date() { return created_date; }
    public void setCreated_date(Date created_date) { this.created_date = created_date; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
		// TODO Auto-generated method stub
		
	}
