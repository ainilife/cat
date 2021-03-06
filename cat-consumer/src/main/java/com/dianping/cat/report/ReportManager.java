package com.dianping.cat.report;

import java.util.Map;

import com.dianping.cat.report.DefaultReportManager.StoragePolicy;

public interface ReportManager<T> {
	public void cleanup();

	public T getHourlyReport(long startTime, String domain, boolean createIfNotExist);

	public Map<String, T> getHourlyReports(long startTime);

	public Map<String, T> loadHourlyReports(long startTime, StoragePolicy policy);

	public void storeHourlyReports(long startTime, StoragePolicy policy);
}
