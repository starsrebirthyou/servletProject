package everytable.menu.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.member.vo.LoginVO;
import everytable.menu.dao.MenuDAO;
import everytable.menu.vo.MenuVO;
import everytable.store.dao.StoreDAO;
import everytable.store.vo.StoreVO;

public class MenuController implements Controller {
    @Override
    public String execute(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String jsp = "";

        try {
            switch (uri) {

                // 1. 메뉴 리스트 (점주 관리용 - 품절 포함 전체)
                case "/menu/list.do":
                    String strStoreId = request.getParameter("store_id");

                    // store_id 없으면 로그인 ID로 매장 조회 후 자동 리다이렉트
                    if (strStoreId == null || strStoreId.trim().isEmpty() || strStoreId.equals("null")) {
                        HttpSession session = request.getSession(false);
                        if (session == null) return "redirect:/member/loginForm.do";

                        LoginVO loginVO = (LoginVO) session.getAttribute("login");
                        if (loginVO == null) return "redirect:/member/loginForm.do";

                        StoreDAO storeDAO = new StoreDAO();
                        StoreVO storeVO = storeDAO.findByMemberId(loginVO.getId());

                        if (storeVO == null) return "redirect:/store/write.do";
                        return "redirect:list.do?store_id=" + storeVO.getStore_id();
                    }

                    Long store_id = Long.parseLong(strStoreId.trim());
                    request.setAttribute("vo", Init.getService("/store/view.do").service(store_id));

                    // ✅ listAll() - 품절 포함 전체 조회 (점주 관리용)
                    MenuDAO menuDAO = new MenuDAO();
                    request.setAttribute("menuList", menuDAO.listAll(store_id));
                    request.setAttribute("store_id", store_id);
                    jsp = "menu/list";
                    break;

                // 2. 메뉴 등록
                case "/menu/write.do":
                    String writeStoreId = request.getParameter("store_id");
                    if (request.getMethod().equals("POST")) {
                        MenuVO writeVo = new MenuVO();
                        writeVo.setStore_id  (Long.parseLong(writeStoreId.trim()));
                        writeVo.setMenu_name (request.getParameter("menu_name"));
                        writeVo.setPrice     (Integer.parseInt(request.getParameter("price")));
                        writeVo.setDescription(request.getParameter("description"));
                        writeVo.setImage_url (request.getParameter("image_url"));

                        Init.getService(uri).service(writeVo);
                        jsp = "redirect:list.do?store_id=" + writeStoreId;
                    } else {
                        request.setAttribute("store_id", writeStoreId);
                        jsp = "menu/write";
                    }
                    break;

                // 3. 메뉴 수정
                case "/menu/update.do":
                    String updateStoreId = request.getParameter("store_id");
                    if (request.getMethod().equals("POST")) {
                        MenuVO vo = new MenuVO();
                        vo.setMenu_no    (Long.parseLong(request.getParameter("menu_no")));
                        vo.setMenu_name  (request.getParameter("menu_name"));
                        vo.setPrice      (Integer.parseInt(request.getParameter("price")));
                        vo.setDescription(request.getParameter("description"));
                        vo.setImage_url  (request.getParameter("image_url"));

                        Init.getService(uri).service(vo);
                        jsp = "redirect:list.do?store_id=" + updateStoreId;
                    } else {
                        Long menu_no = Long.parseLong(request.getParameter("menu_no"));
                        request.setAttribute("vo", Init.getService("/menu/view.do").service(menu_no));
                        request.setAttribute("store_id", updateStoreId);
                        jsp = "menu/update";
                    }
                    break;

                // 4. 메뉴 삭제
                case "/menu/delete.do":
                    String deleteStoreId = request.getParameter("store_id");
                    Long deleteMenuNo = Long.parseLong(request.getParameter("menu_no"));

                    Init.getService(uri).service(deleteMenuNo);

                    if (deleteStoreId == null || deleteStoreId.equals("null")) {
                        jsp = "redirect:/store/list.do";
                    } else {
                        jsp = "redirect:list.do?store_id=" + deleteStoreId;
                    }
                    break;

                // 5. 메뉴 상태 변경 (판매중 ↔ 품절 토글)
                case "/menu/changeStatus.do":
                    MenuVO statusVo = new MenuVO();
                    statusVo.setMenu_no  (Long.parseLong(request.getParameter("menu_no")));
                    statusVo.setIs_active(Integer.parseInt(request.getParameter("is_active")));

                    Init.getService(uri).service(statusVo);
                    jsp = "redirect:list.do?store_id=" + request.getParameter("store_id");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("exception", e);
            jsp = "error/500";
        }
        return jsp;
    }
}