
library(dplyr)
library(divDyn)
library(ggplot2)
library(RColorBrewer)

data("stages")

# 读取输入文件
df <- read.table("total.Actinopterygii.species.Final.Success", header = TRUE, sep = "\t")

# 删除Max_time大于430 ma 的记录
df <- df[df$Max_time <= 410, ]

# 将指定的Group替换为新的名称
df$Group <- ifelse(df$Group %in% c("Scanilepiformes", "Acipenseriformes_Chondrostei", "stem-Actinopteri", "Holostei", "stem-Neopterygii"),
                   "non-teleost crown-group Actinopterygii", df$Group)

# 保存为新的文件
new_file <- "total.Actinopterygii.species.Final.Success_new"
write.table(df, new_file, sep = "\t", row.names = FALSE)

#  读取新的文件
df_new <- read.table("total.Actinopterygii.species.Final.Success_new", header = TRUE, sep = "\t")

# 根据Group进行分组
df_grouped <- df_new %>% group_by(Group)

# 对每个组进行按比例取样
sample_frac <- 0.9
df_sampled <- df_grouped %>% sample_frac(sample_frac, replace = FALSE) %>% ungroup()

# 将抽样结果保存为新的表格
list_of_tables <- split(df_sampled, df_sampled$Group)
file_names <- paste0(names(list_of_tables), ".txt")
lapply(seq_along(list_of_tables), function(i) {
  write.table(list_of_tables[[i]], file_names[i], sep = "\t", row.names = FALSE)
})

# 读取新表格数据，添加Mean_time列
new_tables <- lapply(file_names, function(file) {
  df_new <- read.table(file, header = TRUE, sep = "\t")
  df_new$Mean_time <- rowMeans(df_new[, c("Max_time", "Min_time")])
  df_new
})

# 对每个新表格进行切片并保存切片结果
lapply(seq_along(new_tables), function(i) {
  breakPoints <- seq(500, 0, -10)
  df_sliced <- cut(new_tables[[i]]$Mean_time, breaks = breakPoints, labels = FALSE)
  new_tables[[i]]$Slc <- df_sliced
  write.table(new_tables[[i]], file_names[i], sep = "\t", row.names = FALSE, quote = FALSE)
})

# 定义颜色数量
num_colors <- length(file_names)

# 使用Nature配色方案
colors <- brewer.pal(num_colors, "Set2")
#colors <- c("#1F77B4", "#FF7F0E", "#2CA02C", "#D62728")


# 创建一个空白的图形
pdf("Total_species_diversity_dynamics_plot.pdf",width = 159.091, height = 31)

# 创建一个空数据框用于存储合并后的数据
df_merged <- data.frame(Mean_time = numeric(0), divRT = numeric(0), Group = character(0))

# 计算diversity dynamics并保存结果
for (i in seq_along(file_names)) {
  breakPoints <- seq(500, 0, -10)
  df <- read.table(file_names[i], header = TRUE, sep = "\t")
  # 计算diversity dynamics
  ddMid10_genus <- divDyn(df, tax = "Genus", age = "Mean_time", breaks = breakPoints)
  # 在diversity dynamics数据框中添加group信息
  ddMid10_genus$Group <- names(list_of_tables)[i]
  # 将divRT值添加到合并后的数据框中
  df_merged <- bind_rows(df_merged, ddMid10_genus[, c("Mean_time", "divRT", "Group")])
}

# 按照指定顺序排序Group列
df_merged$Group <- factor(df_merged$Group, levels = c("crown-Teleostei", 
                                                      "stem-Teleostei",
                                                      "non-teleost crown Actinopterygii",
                                                      "Stem-Actinopterygii" 
                                                       ))
# 堆积面积图
ggplot(df_merged, aes(x = Mean_time, y = divRT, fill = Group)) +
  geom_area(position = "stack",alpha=0.65) +
  labs(x = "Time", y = "Species Richness", fill = "Group") +
  scale_fill_manual(values = colors) +
  theme_minimal() +
  theme(legend.position = "right")+
  scale_x_reverse()

# 保存图形为pdf文件
dev.off()



# 读取输入文件
df <- read.table("total.Actinopterygii.genus.Final.Success", header = TRUE, sep = "\t")

# 删除Max_time大于430 ma 的记录
df <- df[df$Max_time <= 410, ]

# 将指定的Group替换为新的名称
df$Group <- ifelse(df$Group %in% c("Scanilepiformes", "Acipenseriformes_Chondrostei", "stem-Actinopteri", "Holostei", "stem-Neopterygii"),
                   "non-teleost crown Actinopterygii", df$Group)

# 保存为新的文件
new_file <- "total.Actinopterygii.genus.Final.Success_new"
write.table(df, new_file, sep = "\t", row.names = FALSE)

#  读取新的文件
df_new <- read.table("total.Actinopterygii.genus.Final.Success_new", header = TRUE, sep = "\t")

# 根据Group进行分组
df_grouped <- df_new %>% group_by(Group)

# 对每个组进行按比例取样
sample_frac <- 0.9
df_sampled <- df_grouped %>% sample_frac(sample_frac, replace = FALSE) %>% ungroup()

# 将抽样结果保存为新的表格
list_of_tables <- split(df_sampled, df_sampled$Group)
file_names <- paste0(names(list_of_tables), ".txt")
lapply(seq_along(list_of_tables), function(i) {
  write.table(list_of_tables[[i]], file_names[i], sep = "\t", row.names = FALSE)
})

# 读取新表格数据，添加Mean_time列
new_tables <- lapply(file_names, function(file) {
  df_new <- read.table(file, header = TRUE, sep = "\t")
  df_new$Mean_time <- rowMeans(df_new[, c("Max_time", "Min_time")])
  df_new
})

# 对每个新表格进行切片并保存切片结果
lapply(seq_along(new_tables), function(i) {
  breakPoints <- seq(500, 0, -10)
  df_sliced <- cut(new_tables[[i]]$Mean_time, breaks = breakPoints, labels = FALSE)
  new_tables[[i]]$Slc <- df_sliced
  write.table(new_tables[[i]], file_names[i], sep = "\t", row.names = FALSE, quote = FALSE)
})

# 定义颜色数量
num_colors <- length(file_names)

# 使用Nature配色方案
colors <- brewer.pal(num_colors, "Set2")

# 创建一个空白的图形
pdf("Total_genus_diversity_dynamics_plot.pdf",width = 159.091, height = 31)

# 创建一个空数据框用于存储合并后的数据
df_merged <- data.frame(Mean_time = numeric(0), divRT = numeric(0), Group = character(0))

# 计算diversity dynamics并保存结果
for (i in seq_along(file_names)) {
  breakPoints <- seq(500, 0, -10)
  df <- read.table(file_names[i], header = TRUE, sep = "\t")
  # 计算diversity dynamics
  ddMid10_genus <- divDyn(df, tax = "Genus", age = "Mean_time", breaks = breakPoints)
  # 在diversity dynamics数据框中添加group信息
  ddMid10_genus$Group <- names(list_of_tables)[i]
  # 将divRT值添加到合并后的数据框中
  df_merged <- bind_rows(df_merged, ddMid10_genus[, c("Mean_time", "divRT", "Group")])
}

# 按照指定顺序排序Group列
df_merged$Group <- factor(df_merged$Group, levels = c("crown-Teleostei",
                                                      "stem-Teleostei",
                                                      "non-teleost crown Actinopterygii",
                                                      "Stem-Actinopterygii" ))
# 堆积面积图
ggplot(df_merged, aes(x = Mean_time, y = divRT, fill = Group)) +
  geom_area(position = "stack",alpha=0.65) +
  labs(x = "Time", y = "Genus Richness", fill = "Group") +
  scale_fill_manual(values = colors) +
  theme_minimal() +
  theme(legend.position = "right")+
  scale_x_reverse()

# 保存图形为pdf文件
dev.off()
