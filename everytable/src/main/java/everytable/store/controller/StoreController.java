package everytable.store.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.member.vo.LoginVO;
import everytable.store.dao.StoreDAO;
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
                    String perPageNum = request.getParameter("perPageNum");
                    if(perPageNum == null || perPageNum.equals(""))
                    	pageObject.setPerPageNum(9);
                    request.setAttribute("list", Init.getService(uri).service(pageObject));
                    request.setAttribute("pageObject", pageObject);
                    jsp = "store/list";
                    break;

                case "/store/write.do":
                    if (request.getMethod().equals("POST")) {
                        HttpSession writeSession = request.getSession();
                        // ✅ LoginVO에서 id 추출
                        LoginVO writeLogin = (LoginVO) writeSession.getAttribute("login");
                        String memberId = (writeLogin != null) ? writeLogin.getId() : null;

                        StoreVO writeVo = new StoreVO();
                        writeVo.setMember_id(memberId);
                        writeVo.setStore_name(request.getParameter("store_name"));
                        writeVo.setStore_cate(request.getParameter("store_cate"));
                        writeVo.setStore_addr(request.getParameter("store_addr"));
                        writeVo.setStore_tel(request.getParameter("store_tel"));
                        writeVo.setOpen_time(request.getParameter("open_time"));

                        String minPrice = request.getParameter("min_order_price");
                        writeVo.setMin_order_price(minPrice != null && !minPrice.trim().isEmpty()
                                ? Integer.parseInt(minPrice.trim()) : 0);
                        writeVo.setPrepare_time(request.getParameter("prepare_time"));
                        writeVo.setRefund_policy_24(request.getParameter("refund_policy_24"));
                        writeVo.setRefund_policy_12(request.getParameter("refund_policy_12"));
                        writeVo.setRefund_policy_0(request.getParameter("refund_policy_0"));

                        String filename = request.getParameter("filename");
                        writeVo.setFilename(filename != null && !filename.trim().isEmpty()
                                ? filename.trim() : "default.jpg");

                        Init.getService(uri).service(writeVo);
                        jsp = "redirect:list.do";
                    } else {
                        jsp = "store/write";
                    }
                    break;

                case "/store/view.do":
                    String strStoreId = request.getParameter("store_id");
                    if (strStoreId == null || strStoreId.trim().isEmpty()) {
                        return "redirect:list.do";
                    }
                    Long store_id = Long.parseLong(strStoreId.trim());
                    request.setAttribute("vo", Init.getService(uri).service(store_id));
                    request.setAttribute("menuList", Init.getService("/menu/list.do").service(store_id));
                    jsp = "store/view";
                    break;

                case "/store/update.do":
                    HttpSession session = request.getSession();
                    // ✅ "id" 대신 "login" 키로 LoginVO 꺼내기
                    LoginVO loginVO = (LoginVO) session.getAttribute("login");

                    if (loginVO == null) {
                        return "redirect:/member/loginForm.do";
                    }
                    String loginId = loginVO.getId();

                    String updateStoreId = request.getParameter("store_id");

                    // ✅ store_id 없으면 로그인 ID로 매장 조회 후 자동 리다이렉트
                    if (updateStoreId == null || updateStoreId.trim().isEmpty()) {
                        StoreDAO dao = new StoreDAO();
                        StoreVO myStore = dao.findByMemberId(loginId);

                        if (myStore == null) {
                            // 등록된 매장 없으면 등록 페이지로
                            return "redirect:write.do";
                        }
                        return "redirect:update.do?store_id=" + myStore.getStore_id();
                    }

                    Long updateId = Long.parseLong(updateStoreId.trim());

                    if (request.getMethod().equals("POST")) {
                        StoreVO vo = new StoreVO();
                        vo.setStore_id(updateId);
                        vo.setStore_name(request.getParameter("store_name"));
                        vo.setStore_cate(request.getParameter("store_cate"));
                        vo.setStore_addr(request.getParameter("store_addr"));
                        vo.setStore_tel(request.getParameter("store_tel"));
                        vo.setOpen_time(request.getParameter("open_time"));

                        String minPrice = request.getParameter("min_order_price");
                        vo.setMin_order_price(minPrice != null && !minPrice.trim().isEmpty()
                                ? Integer.parseInt(minPrice.trim()) : 0);
                        vo.setPrepare_time(request.getParameter("prepare_time"));
                        vo.setRefund_policy_24(request.getParameter("refund_policy_24"));
                        vo.setRefund_policy_12(request.getParameter("refund_policy_12"));
                        vo.setRefund_policy_0(request.getParameter("refund_policy_0"));

                        String newFilename = request.getParameter("filename");
                        if (newFilename != null && !newFilename.trim().isEmpty()) {
                            vo.setFilename(newFilename.trim());
                        }

                        Init.getService(uri).service(vo);
                        jsp = "redirect:update.do?store_id=" + updateStoreId.trim() + "&result=success";
                    } else {
                        StoreVO vo = (StoreVO) Init.getService("/store/view.do").service(updateId);
                        request.setAttribute("vo", vo);
                        if ("success".equals(request.getParameter("result"))) {
                            request.setAttribute("result", "success");
                        }
                        jsp = "store/update";
                    }
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