package egov.mes.defective.dao;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("DefectiveMapper")
public interface DefectiveMapper {
	List<DefectiveVO> findPodtCode(DefectiveVO defective) ;
	List<DefectiveVO> selectDefective(DefectiveVO defective) ;
	List<DefectiveVO> selectProcess(DefectiveVO defective) ;
	List<DefectiveVO> selectChart(DefectiveVO defective) ;
}
