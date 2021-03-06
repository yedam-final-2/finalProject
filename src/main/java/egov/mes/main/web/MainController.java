package egov.mes.main.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;

import egov.mes.main.dao.SidebarMenuVO;
import egov.mes.main.service.SidebarService;

@Controller
public class MainController {
	@Autowired
	private SidebarService sidebarS; 
	
	@RequestMapping("/main.do")
	public String initMain() throws Exception {

		return "main/main.tiles";
	}	
	@RequestMapping("/login.do")
	public String init() throws Exception {

		return "egovframework/com/uat/uia/EgovLoginUsr";
	}
	@RequestMapping("/reqsidebar")
	public String reqside(Model model,String uid) {
		List<SidebarMenuVO> list = new ArrayList<>();
		list = sidebarS.selectsideList(uid);
		model.addAttribute("resultsidebar", list);
		
		return "jsonView";
		
	}
}