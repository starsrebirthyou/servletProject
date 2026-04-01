package everytable.main.controller;

import jakarta.servlet.http.HttpServletRequest;

public interface Controller {

	// Controller를 실행시키기 위한 메서드
	public String execute(HttpServletRequest request);
	
}
