package egov.mes.Proc.service;

import java.util.List;

import egov.mes.Proc.dao.ProcessControlVO;

public interface ProcessControlService {
	
	List<ProcessControlVO> AllFind();	 	//공정 전체조회
	List<ProcessControlVO> EmpFind(); 		//사원조회(반장만)
	List<ProcessControlVO> FacFind(); 		//설비목록 전체조회
	List<ProcessControlVO> SelectedFac(String ProcCode); 	//선택중인 설비목록 보기
	
	int ProcDelete 		(List<ProcessControlVO> procVO);		//process 테이블데이터 단건삭제
	int CommonDelete 	(List<ProcessControlVO> procVO);		//common_code 테이블 단건삭제
	void FacDataDelt 	(List<ProcessControlVO> procVO);	 //facility_process 선택적 삭제
	
	int ProcAddData 	(List<ProcessControlVO> ProcVO);	//process 테이블 데이터 추가
	int CommonAddData 	(List<ProcessControlVO> ProcVO);	//common_code 테이블 데이터 추가
	
	void FacProcInput 	(List<ProcessControlVO> ProcVO);	//facility_process 테이블 데이터 추가

	void ProcChangeData (List<ProcessControlVO> ProcVO); 	 //process 테이블 데이터 수정
	void CommonChangeData (List<ProcessControlVO> ProcVO);	 //common_code 테이블 데이터 수정
}
