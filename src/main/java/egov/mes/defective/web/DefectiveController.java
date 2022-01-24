package egov.mes.defective.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import egov.mes.defective.dao.DefectiveVO;
import egov.mes.defective.service.DefectiveService;

@Controller
public class DefectiveController {

	@Autowired DefectiveService service ;
	
	// egov 메인에서 defective_product.jsp로 연결
	@RequestMapping("DefectiveProduct")
	public String DefectiveManagement() {
		return "defective_product/defective_product.tiles" ;
	}
	
	// 작업일자별 제품조회
	@PostMapping("/defective/findProduct")
	public String findPodtCode(DefectiveVO defective , Model model) {
		
		if(defective.getFromDate().equals("null")) {
			defective.setFromDate(null) ;
		}
		if(defective.getToDate().equals("null")) {
			defective.setToDate(null) ;
		}
		
		model.addAttribute("result" , service.findPodtCode(defective)) ;
		
		return "jsonView" ;
	}
	
	@PostMapping("/defective/main")
	public String selectDefective(DefectiveVO defective , Model model) {
		
		model.addAttribute("result" , service.selectDefective(defective)) ;
		
		return "jsonView" ;
		
	}
}
