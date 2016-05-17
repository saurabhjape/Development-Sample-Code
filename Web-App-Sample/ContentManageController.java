import java.util.*;

import static com.cisco.cpc.common.CPCConstants.CONSTANT_UPPER_Y;
import static com.cisco.bnp.common.BnpConstants.BNP_SESSION_ATTRIBUTES;

@Controller
@RequestMapping("/content/manage")
@SessionAttributes({
        USERBEAN,
        BNP_SESSION_ATTRIBUTES,
})
public class ContentManageController
{
	private static String DEFAULT_LANGUAGE = "en_US";
	private static Logger LOGGER = Logger.getLogger(ContentManageController.class);


	@Autowired
	@Qualifier("contentDocumentManagmentService")
	private ContentDocumentManagementService cdService;

	@Autowired
	@Qualifier("contentManagmentService")
	private ContentManagementService cService;   

    @RequestMapping(value="/populateTechnologyList", method=RequestMethod.GET)
    protected ModelAndView populateTechnologyList(@ModelAttribute(BNP_SESSION_ATTRIBUTES) BnpSessionAttributes bnpSessionAttributes) throws Exception {
    	ModelAndView model = new ModelAndView("cmsViews/technologyListDoc");
    	try{
    		List<TechnologyList> technologyList = new ArrayList<TechnologyList>();
    			if(BnpConstants.CMS_ROLE_SUPER_ADMIN.equalsIgnoreCase(bnpSessionAttributes.getCmsUserHighestRole())) {	
	    			List parentConceptId = cService.getParentConceptId();
	        		int parentId = (Integer) parentConceptId.get(0);
	        		List<AllTechnologyList> cpcNodeTechnologyList = cService.getCPCNodeTechnology(parentId);
	        		List<CustomTechnologyList> customTechnologyList = cService.getCustomTechnology();
	        		for(AllTechnologyList cpcNodeData : cpcNodeTechnologyList){
	        			TechnologyList technology= new TechnologyList();
	        			technology.setTechnologyId(cpcNodeData.getConceptId());
	        			technology.setTechnology(cpcNodeData.getTitle());
	        			technologyList.add(technology);
	        		}
	        		for(CustomTechnologyList customData : customTechnologyList){
	        			TechnologyList technology= new TechnologyList();
	        			technology.setTechnologyId(customData.getConceptId());
	        			technology.setTechnology(customData.getConceptValue());
	        			boolean techFound = false;
	        			for(TechnologyList techList:technologyList){
	        				if(techList.getTechnology().equals(customData.getConceptValue())){
	        					techFound = true;
	        				}
	        			}
	        			if(!techFound){
	        				technologyList.add(technology);
	        			}
	        		}    			
	    		}else{
	    			// Check technologies that user has access to
	    			UserBean userBean = CPCUtils.getAccessContext().getUserBean();
	    			List<UserManagement> usermgmtList = cService.findUserTechAndRole(userBean.getCcoUserId());
	    			 
	    		 	List<TechnologyList> technoList = new ArrayList<TechnologyList>();
	    			List parentConceptId = cService.getParentConceptId();
	    			int parentId = (Integer) parentConceptId.get(0);
	    			List<AllTechnologyList> cpcNodeTechnologyList = cService.getCPCNodeTechnology(parentId);
	    			List<CustomTechnologyList> customTechnologyList = cService.getCustomTechnology();
	    			for(AllTechnologyList cpcNodeData : cpcNodeTechnologyList){
	    				TechnologyList technology= new TechnologyList();
	    				technology.setTechnologyId(cpcNodeData.getConceptId());
	    				technology.setTechnology(cpcNodeData.getTitle());
	    				technoList.add(technology);
	    			}
	    			for(CustomTechnologyList customData : customTechnologyList){
	    				TechnologyList technology= new TechnologyList();
	    				technology.setTechnologyId(customData.getConceptId());
	    				technology.setTechnology(customData.getConceptValue());
	    				boolean techFound = false;
	    				for(TechnologyList techList:technoList){
	    					if(techList.getTechnology().equals(customData.getConceptValue())){
	    						techFound = true;
	    					}
	    				}
	    				if(!techFound){
	    					technoList.add(technology);
	    				}
	    			}
	    			//Fetch Technology Names from id
	    	        for (UserManagement userMgmtAccess : usermgmtList) {
	    	        	for(TechnologyList tech : technoList){
	    	        		if(userMgmtAccess.getTechnology()==tech.getTechnologyId()){
	    	        			TechnologyList technology = new TechnologyList();
	    	        			technology.setTechnology(tech.getTechnology());
	    	        			technology.setTechnologyId((int) userMgmtAccess.getTechnology());
	    	        			technologyList.add(technology);
	    	        		}
	    	        	}
	    	        }	
	    		}
    		model.addObject("contextContextJsonArray",technologyList);
    	}catch(Exception e){
    		BnpAjaxTextException bate = new BnpAjaxTextException("Error in getting technology List", e);
    		throw bate;
    	}
    	return model;
    }
}