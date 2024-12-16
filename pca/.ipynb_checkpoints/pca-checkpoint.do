*===========================================================================
* Author: pf.zh
* Date: 2024-11-25
* Description: This DO file generates 4 correlated variables, performs Principal 
* Component Analysis (PCA) on these variables, and generates the principal 
* components. It also computes and displays the covariance matrices for both 
* the principal components and the original variables.
* 
* This DO file performs the following tasks:
* - Task 1: Sets sample size to 100 and initializes random number generator seed
* - Task 2: Generates 4 correlated variables (x1, x2, x3, x4)
* - Task 3: Performs Principal Component Analysis (PCA) on the variables
* - Task 4: Generates the first four principal components based on PCA
* - Task 5: Optionally standardizes the original variables
* - Task 6: Computes and displays the covariance matrices for the principal 
*   components and the original variables
* 
* Usage: Run this DO file to perform PCA and view the covariance matrices.
* 
* Note: Make sure the dataset is loaded before running the script if 
*       modifications are needed.
*===========================================================================
 

* 设置样本量与种子
set obs 100
set seed 12345

* 生成 4 个相关变量
gen x1 = rnormal(0, 1)
gen x2 = 0.5 * x1 + rnormal(0, 1)
gen x3 = 0.3 * x1 + 0.3 * x2 + rnormal(0, 1)
gen x4 = 0.2 * x1 + 0.4 * x2 + 0.2 * x3 + rnormal(0, 1)

* 进行主成分分析
pca x1 x2 x3 x4

* 生成主成分
predict pc1 pc2 pc3 pc4

* 可选 -> 变量标注化
foreach var in x1 x2 x3 x4 {
    egen z_`var' = std(`var')
}

* 主成分的协方差矩阵
corr pc1 pc2 pc3 pc4

* 原变量的协方差矩阵
corr x1 x2 x3 x4
