package com.dianping.cat.system.page.abtest;

import com.dianping.cat.system.SystemPage;
import org.unidal.web.mvc.view.BaseJspViewer;

public class JspViewer extends BaseJspViewer<SystemPage, Action, Context, Model> {
	@Override
	protected String getJspFilePath(Context ctx, Model model) {
		Action action = model.getAction();

		switch (action) {
		case VIEW:
			return JspFile.VIEW.getPath();
		case CREATE:
			return JspFile.CREATE.getPath();
		case DETAIL:
			return JspFile.DETAIL.getPath();
		case REPORT:
			return JspFile.REPORT.getPath();
		case MODEL:
			return JspFile.MODEL.getPath();
			
		}

		throw new RuntimeException("Unknown action: " + action);
	}
}
