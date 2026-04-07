package everytable.menu.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.menu.vo.MenuVO;
import everytable.util.db.DB;

public class MenuDAO extends DAO {

    public List<MenuVO> list(Long storeId, boolean isAdmin) throws Exception {
        List<MenuVO> list = null;
        try {
            con = DB.getConnection();
            String sql = "select * from menu where store_id = ?" + (isAdmin ? "" : " and is_active = 1");
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, storeId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                if (list == null) list = new ArrayList<>();
                MenuVO vo = new MenuVO();
                vo.setMenu_no(rs.getLong("menu_no"));
                vo.setStore_id(rs.getLong("store_id"));
                vo.setMenu_name(rs.getString("menu_name"));
                vo.setPrice(rs.getInt("price"));
                vo.setDescription(rs.getString("description"));
                vo.setImage_url(rs.getString("image_url"));
                vo.setIs_active(rs.getInt("is_active"));
                list.add(vo);
            }
        } finally { DB.close(con, pstmt, rs); }
        return list;
    }

    public MenuVO view(Long menu_no) throws Exception {
        MenuVO vo = null;
        try {
            con = DB.getConnection();
            String sql = "select * from menu where menu_no = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, menu_no);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                vo = new MenuVO();
                vo.setMenu_no(rs.getLong("menu_no"));
                vo.setStore_id(rs.getLong("store_id"));
                vo.setMenu_name(rs.getString("menu_name"));
                vo.setPrice(rs.getInt("price"));
                vo.setDescription(rs.getString("description"));
                vo.setImage_url(rs.getString("image_url"));
                vo.setIs_active(rs.getInt("is_active"));
            }
        } finally { DB.close(con, pstmt, rs); }
        return vo;
    }

    public int changeStatus(MenuVO vo) throws Exception {
        int result = 0;
        try {
            con = DB.getConnection();
            String sql = "update menu set is_active = ? where menu_no = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, vo.getIs_active());
            pstmt.setLong(2, vo.getMenu_no());
            result = pstmt.executeUpdate();
        } finally { DB.close(con, pstmt, rs); }
        return result;
    }

    public int update(MenuVO vo) throws Exception {
        int result = 0;
        try {
            con = DB.getConnection();
            String sql = "update menu set menu_name=?, price=?, description=?, image_url=? where menu_no=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, vo.getMenu_name());
            pstmt.setInt(2, vo.getPrice());
            pstmt.setString(3, vo.getDescription());
            pstmt.setString(4, vo.getImage_url());
            pstmt.setLong(5, vo.getMenu_no());
            result = pstmt.executeUpdate();
        } finally { DB.close(con, pstmt, rs); }
        return result;
    }

    public int delete(Long menu_no) throws Exception {
        int result = 0;
        try {
            con = DB.getConnection();
            String sql = "delete from menu where menu_no = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, menu_no);
            result = pstmt.executeUpdate();
        } finally { DB.close(con, pstmt, rs); }
        return result;
    }
    public int write(MenuVO vo) throws Exception {
        int result = 0;
        try {
            con = DB.getConnection();
            String sql = "insert into menu (menu_no, store_id, menu_name, price, description, image_url, is_active, created_date) "
                       + "values (menu_seq.NEXTVAL, ?, ?, ?, ?, ?, 1, SYSDATE)";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, vo.getStore_id());
            pstmt.setString(2, vo.getMenu_name());
            pstmt.setInt(3, vo.getPrice());
            pstmt.setString(4, vo.getDescription());
            pstmt.setString(5, vo.getImage_url());
            result = pstmt.executeUpdate();
        } finally { DB.close(con, pstmt, rs); }
        return result;
    }
}