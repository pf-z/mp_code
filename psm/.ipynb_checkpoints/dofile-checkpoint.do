clear all
set seed 42
set obs 1000

* 生成模拟数据
gen X1 = rnormal(0, 1)
gen X2 = rnormal(5, 2)
gen T = runiform() > 0.5
replace X1 = X1 + 2 if T == 1
replace X2 = X2 - 1 if T == 0

* 标准化协变量
egen std_X1 = std(X1)
egen std_X2 = std(X2)
drop X1 X2
rename std_X1 X1
rename std_X2 X2

* 倾向得分匹配
psmatch2 T X1 X2, out(T) neighbor(1) common

* 生成倾向得分分布图并保存
psgraph, treated(T) pscore(_pscore) graphregion(color(white)) title("Propensity Score Distribution") xtitle("Propensity Score") ytitle("Density") legend(label(1 "Treated") label(2 "Control (Original)") label(3 "Control (Matched)") size(small)) name(psgraph, replace)
graph save "ps_distribution.gph", replace

* 生成标准化偏差图并保存
pstest X1 X2, treated(T) graph graphregion(color(white)) title("Standardized Mean Differences") xtitle("Standardized Difference (SMD)") ytitle("Covariates") legend(label(1 "Before Matching") label(2 "After Matching") size(small)) name(pstest, replace)
graph save "smd_plot.gph", replace

* 组合 1×2 图形
graph combine psgraph pstest, cols(2) graphregion(color(white)) title("Propensity Score Matching Diagnostics", size(medium)) xsize(10) ysize(4)
graph export "combined_plot.png", replace

* 输出样本量
qui count if T==1
local original_treated = r(N)
qui count if T==0
local original_control = r(N)
qui count if _weight==1 & T==0
local matched_control = r(N)
local total_matched = `original_treated' + `matched_control'
di _n "样本量统计："
di "========================================"
di "原始治疗组：" _col(20) %10.0f `original_treated'
di "原始控制组：" _col(20) %10.0f `original_control'
di "匹配控制组：" _col(20) %10.0f `matched_control'
di "总匹配样本：" _col(20) %10.0f `total_matched'
di "========================================"
