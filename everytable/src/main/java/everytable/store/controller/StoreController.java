package everytable.store.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.store.vo.StoreVO;
import everytable.util.page.PageObject;

public class StoreController implements Controller {

    @Override
    public String execute(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String jsp = "";

        try {
            switch (uri) {

                case "/store/list.do":
                    PageObject pageObject = PageObject.getInstance(request);
                    request.setAttribute("list", Init.getService(uri).service(pageObject));
                    request.setAttribute("pageObject", pageObject);
                    jsp = "store/list";
                    break;

                case "/store/write.do":
                    if (request.getMethod().equals("POST")) {
                        // ✅ 세션에서 로그인한 member_id 가져오기
                        HttpSession session = request.getSession();
                        String memberId = (String) session.getAttribute("id"); // 세션 키명 확인 필요

                        StoreVO writeVo = new StoreVO();
                        writeVo.setMember_id(memberId);
                        writeVo.setStore_name(request.getParameter("store_name"));
                        writeVo.setStore_cate(request.getParameter("store_cate"));
                        writeVo.setStore_addr(request.getParameter("store_addr"));
                        writeVo.setStore_tel(request.getParameter("store_tel"));
                        writeVo.setOpen_time(request.getParameter("open_time"));
                        String minPrice = request.getParameter("min_order_price");
                        writeVo.setMin_order_price(minPrice != null && !minPrice.isEmpty()
                                ? Integer.parseInt(minPrice) : 0);
                        writeVo.setPrepare_time(request.getParameter("prepare_time"));

                        String filename = request.getParameter("filename");
                        writeVo.setFilename(filename != null ? filename : "default.jpg");

                        Init.getService(uri).service(writeVo);
                        jsp = "redirect:list.do";
                    } else {
                        // GET: 등록 폼 표시
                        jsp = "store/write";
                    }
                    break;

                case "/store/view.do":
                    String strStoreId = request.getParameter("store_id");
                    if (strStoreId == null || strStoreId.trim().isEmpty()) {
                        return "redirect:list.do";
                    }
                    Long store_id = Long.parseLong(strStoreId);
                    request.setAttribute("vo", Init.getService(uri).service(store_id));
                    request.setAttribute("menuList", Init.getService("/menu/list.do").service(store_id));
                    jsp = "store/view";
                    break;

                case "/store/update.do":
                    String updateStoreId = request.getParameter("store_id");
                    if (updateStoreId == null || updateStoreId.trim().isEmpty()) {
                        return "redirect:list.do";
                    }
                    Long updateId = Long.parseLong(updateStoreId);

                    if (request.getMethod().equals("POST")) {
                        StoreVO vo = new StoreVO();
                        vo.setStore_id(updateId);
                        vo.setStore_name(request.getParameter("store_name"));
                        vo.setStore_cate(request.getParameter("store_cate"));
                        vo.setStore_addr(request.getParameter("store_addr"));
                        vo.setStore_tel(request.getParameter("store_tel"));
                        vo.setOpen_time(request.getParameter("open_time"));
                        String minPrice = request.getParameter("min_order_price");
                        vo.setMin_order_price(minPrice != null && !minPrice.isEmpty()
                                ? Integer.parseInt(minPrice) : 0);
                        vo.setPrepare_time(request.getParameter("prepare_time"));
                        String newFilename = request.getParameter("filename");
                        if (newFilename != null && !newFilename.isEmpty()) {
                            vo.setFilename(newFilename);
                        }
                        Init.getService(uri).service(vo);
                        jsp = "redirect:update.do?store_id=" + updateStoreId + "&result=success";
                    } else {
                        StoreVO vo = (StoreVO) Init.getService("/store/view.do").service(updateId);
                        request.setAttribute("vo", vo);
                        String result = request.getParameter("result");
                        if ("success".equals(result)) {
                            request.setAttribute("result", "success");
                        }
                        jsp = "store/update";
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsp = "error/500";
        }
        return jsp;
    }
}
