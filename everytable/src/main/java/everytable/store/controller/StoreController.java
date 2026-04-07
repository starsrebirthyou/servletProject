package everytable.store.controller;

import jakarta.servlet.http.HttpServletRequest;
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
                        // ✅ 수정 처리
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
                        // 이미지 파일명 (파일 업로드 구현 시 여기서 처리)
                        String newFilename = request.getParameter("filename");
                        if (newFilename != null && !newFilename.isEmpty()) {
                            vo.setFilename(newFilename);
                        }
                        Init.getService(uri).service(vo);
                        jsp = "redirect:update.do?store_id=" + updateStoreId + "&result=success";
                    } else {
                        // ✅ 수정 폼 로드
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