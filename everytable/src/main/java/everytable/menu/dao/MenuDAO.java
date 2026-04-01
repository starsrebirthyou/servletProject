package everytable.menu.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.menu.vo.MenuVO;
import everytable.util.db.DB;

public class MenuDAO extends DAO {
    public List<MenuVO> list(Long storeId) throws Exception {
        List<MenuVO> list = null;
        try {
            con = DB.getConnection();
            String sql = "select menu_no, menu_name, price, description, image_url from menu where store_id = ? and is_active = 1";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, storeId);
            rs = pstmt.executeQuery();
            while (rs != null && rs.next()) {
                if (list == null) list = new ArrayList<>();
                MenuVO vo = new MenuVO();
                vo.setMenu_no(rs.getLong("menu_no"));
                vo.setMenu_name(rs.getString("menu_name"));
                vo.setPrice(rs.getLong("price"));
                vo.setDescription(rs.getString("description"));
                vo.setImage_url(rs.getString("image_url"));
                list.add(vo);
            }
        } finally { DB.close(con, pstmt, rs); }
        return list;
    }
}