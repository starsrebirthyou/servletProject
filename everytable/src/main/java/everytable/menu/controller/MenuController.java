package everytable.menu.controller;

import jakarta.servlet.http.HttpServletRequest;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.menu.vo.MenuVO;

public class MenuController implements Controller {
    @Override
    public String execute(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String jsp = "";

        try {
            switch (uri) {
                case "/menu/list.do":
                    String strStoreId = request.getParameter("store_id");
                    if (strStoreId == null || strStoreId.trim().isEmpty() || strStoreId.equals("null")) {
                        return "redirect:/store/list.do";
                    }
                    Long store_id = Long.parseLong(strStoreId);
                    request.setAttribute("vo", Init.getService("/store/view.do").service(store_id));
                    request.setAttribute("menuList", Init.getService(uri).service(store_id));
                    jsp = "menu/list";
                    break;

                case "/menu/write.do":
                    String writeStoreId = request.getParameter("store_id");
                    if (request.getMethod().equals("POST")) {
                        // 등록 처리
                        MenuVO writeVo = new MenuVO();
                        writeVo.setStore_id(Long.parseLong(writeStoreId));
                        writeVo.setMenu_name(request.getParameter("menu_name"));
                        writeVo.setPrice(Integer.parseInt(request.getParameter("price")));
                        writeVo.setDescription(request.getParameter("description"));
                        writeVo.setImage_url(request.getParameter("image_url"));
                        Init.getService(uri).service(writeVo);
                        jsp = "redirect:list.do?store_id=" + writeStoreId;
                    } else {
                        // 등록 폼 로드
                        request.setAttribute("store_id", writeStoreId);
                        jsp = "menu/write";
                    }
                    break;

                case "/menu/update.do":
                    String updateStoreId = request.getParameter("store_id");
                    if (request.getMethod().equals("POST")) {
                        MenuVO vo = new MenuVO();
                        vo.setMenu_no(Long.parseLong(request.getParameter("menu_no")));
                        vo.setMenu_name(request.getParameter("menu_name"));
                        vo.setPrice(Integer.parseInt(request.getParameter("price")));
                        vo.setDescription(request.getParameter("description"));
                        vo.setImage_url(request.getParameter("image_url"));
                        Init.getService(uri).service(vo);
                        jsp = "redirect:list.do?store_id=" + updateStoreId;
                    } else {
                        Long menu_no = Long.parseLong(request.getParameter("menu_no"));
                        request.setAttribute("vo", Init.getService("/menu/view.do").service(menu_no));
                        request.setAttribute("store_id", updateStoreId);
                        jsp = "menu/update";
                    }
                    break;

                case "/menu/delete.do":
                    String deleteStoreId = request.getParameter("store_id");
                    System.out.println("MenuController.delete() store_id = " + deleteStoreId);
                    System.out.println("MenuController.delete() menu_no  = " + request.getParameter("menu_no"));
                    Long deleteMenuNo = Long.parseLong(request.getParameter("menu_no"));
                    Init.getService(uri).service(deleteMenuNo);
                    if (deleteStoreId == null || deleteStoreId.equals("null")) {
                        jsp = "redirect:/store/list.do";
                    } else {
                        jsp = "redirect:list.do?store_id=" + deleteStoreId;
                    }
                    break;

                case "/menu/changeStatus.do":
                    MenuVO statusVo = new MenuVO();
                    statusVo.setMenu_no(Long.parseLong(request.getParameter("menu_no")));
                    statusVo.setIs_active(Integer.parseInt(request.getParameter("is_active")));
                    Init.getService(uri).service(statusVo);
                    jsp = "redirect:list.do?store_id=" + request.getParameter("store_id");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsp = "error/500";
        }
        return jsp;
    }
}