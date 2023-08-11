# code for data analysis of study on fragments

# set up
library("ggplot2")
library("Rmisc")
library("lme4")
library("dplyr")
library("ordinal")
library("ggmosaic")
library("patchwork")

# read in data
all.dat <- read.csv("full_dataset_raw.csv", sep=";", header=TRUE) 

# information about participants 

# total number of participants
nrow(all.dat) /56 #divided by 56 because every participants had 56 trials
# 100

# age
min(all.dat$age, na.rm=T)
# 19 
max(all.dat$age, na.rm=T)
# 73 
mean(all.dat$age, na.rm=T)
# 35.52525

# gender
table(all.dat$gender)/56 #divided by 56 because every participants had 56 trials
# divers  männlich  weiblich
# 2       69         29

# education
table(all.dat$education) /56 #divided by 56 because every participants had 56 trials
#H\xf6herer Abschluss     Abitur             Bachelor 
#35                       29                 27
#kein Abitur 
#9       

# number of participants in each between-subject condition, i.e., written and auditory
table(all.dat$modality)  /56
# auditory  written 
# 57         43

nrow(all.dat)
# 5600

# participants' comments on study
all.dat %>% pull(comments) %>% unique()

# -------------------- Data sorting and cleaning --------------------

# put all filler items in a separate data set
fillerDat <- all.dat[all.dat$trial_type == "Filler",]

# rename column in filler dataset to varying acceptability of filler stimuli (A-E)
colnames(fillerDat)[colnames(fillerDat) == "fragmentType_Acceptability"] = "acceptability"

# only use critical items for analysis
dat <- all.dat[all.dat$trial_type == "Critical",]

# rename column with fragment type 
colnames(dat)[colnames(dat) == "fragmentType_Acceptability"] = "fragment_type"

# write out abbreviations
dat <- dat %>%
  mutate(fragment_type = recode(fragment_type, "L" = "lexical", "F" = "functional"))

nrow(dat) == nrow(fillerDat)
# TRUE

# -------------------- Data plotting --------------------

# participants' age
dat <- dat %>%
  mutate(age_group = ifelse(age < 50, "<50", "50+"))

# write out abbreviations
dat <- dat %>%
  mutate(age_group = replace(age_group, is.na(age_group), "no age provided"))

dat <- dat %>%
  arrange(rev(age_group))

dat %>% 
  ggplot(aes(x = age_group, y = as.numeric(response), color = age_group)) +
  geom_jitter(height = 0) + 
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20)) +
  guides(color = guide_legend(override.aes = list(size = 10))) +
  labs(title = "Perceived naturalness by age group",
       x = "age group", y = "perceived naturalness") +
  scale_color_discrete(name = "age group")+
  scale_y_continuous(breaks=c(1:7)) 

dat %>% 
  group_by(age_group) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

# emphasis
dat %>% 
  group_by(emphasis) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

dat %>% 
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) +
  geom_jitter(height = 0) + 
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  labs(title = "Perceived naturalness of stimuli with and wihtout emphasis",
       x = "emphasis", y = "perceived naturalness") +
    scale_y_continuous(breaks=c(1:7))

# modality
dat %>% 
  group_by(modality) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

dat %>% 
  ggplot(aes(x = modality, y = as.numeric(response), color = modality)) +
  geom_jitter(height = 0) + 
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  labs(title = "Perceived naturalness of auditory and written stimuli",
       x = "modality", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:7))

# fragment type
dat %>% 
  group_by(fragment_type) %>% 
  summarize(
    mean = mean(as.numeric(response)),
    SD = sd(as.numeric(response))
  )

dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  labs(title = "Perceived naturalness of functional and lexical fragments",
    x = "fragment type", y = "perceived naturalness") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type")+
  scale_y_continuous(breaks=c(1:7))

# all factors in one graph
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  labs(title = "Participants' ratings of all critical items",
       x = "fragment type", y = "perceived naturalness", 
       color = "fragment type") +
  facet_grid(emphasis~modality) +
  scale_y_continuous(breaks=c(1:7))

# including means and standard deviation

# emphasis
sumStatsEmp <- summarySE(dat, measurevar ="response", groupvars = "emphasis")
sumStatsEmp %>%
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) + 
  geom_point() +
  labs(y="percevied naturalness")+
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,7)


# modality
sumStatsMod <- summarySE(dat, measurevar ="response", groupvars = "modality")
sumStatsMod %>%
  ggplot(aes(x = modality, y = as.numeric(response), color = modality)) + 
  geom_point() +
  labs(y="percevied naturalness")+
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,7)


# fragment type
sumStatsFrag <- summarySE(dat, measurevar ="response", groupvars = "fragment_type")
sumStatsFrag %>%
  ggplot(aes(x = fragment_type, y = as.numeric(response), color = fragment_type)) + 
  geom_point() +
  labs(x="fragment type", y="percevied naturalness")+
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,7)

# all factors included
sumStats <- summarySE(dat, measurevar ="response", 
                      groupvars = c("emphasis", "modality", "fragment_type"))
sumStats$ci <- sumStatsMod$ci 
#choosing one of the ci columns to ensure consistency when specifying ymin and ymax
sumStats %>%
  ggplot(aes(x= fragment_type, y = as.numeric(response))) +
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  geom_point() +
  labs(y="percevied naturalness", x="fragment type",
       title = "Participants' ratings of all critical items") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  geom_errorbar(aes(ymin = as.numeric(response) - ci, 
                    ymax = as.numeric(response) + ci), width = 0.1) +
  ylim(1,7) +
  facet_grid(emphasis ~ modality) 

# mosaicplots

mosaic.emp <- dat %>%
  ggplot () +
  geom_mosaic(aes(x = product(response), fill = emphasis)) +
  labs(y="emphasis", x="perceived naturalness") +
  theme_mosaic()

mosaic.mod <- dat %>%
  ggplot () +
  geom_mosaic(aes(x = product(response), fill = modality)) +
  labs(y="modality", x="perceived naturalness") +
  theme_mosaic()

mosaic.frag <- dat %>%
  ggplot () +
  geom_mosaic(aes(x = product(response), fill = fragment_type)) +
  labs(y="fragment type", x="perceived naturalness", fill = "fragment type") +
  theme_mosaic()

combined_plots <- mosaic.emp + mosaic.mod + mosaic.frag +
  plot_layout(ncol = 1) +
  plot_annotation(title = "Participants' ratings shown for each factor",
                  theme = theme(axis.text = element_text(size = 16),
                                axis.title = element_text(size = 16),
                                title = element_text(size = 20)))

print(combined_plots)


# -------------------- Hypotheses testing --------------------

# z-score the responses
responses_z <- scale(as.numeric(dat$response))
dat$responses_z <- responses_z

# CLMM

# First hypothesis
# H0: There is no significant difference between stimuli with and without emphasis.
# H1: Stimuli with emphasis receive higher acceptability ratings than stimuli without emphasis.
# tested by linear mixed model
# as by this method:
emp.clmm = clmm(as.factor(response) ~ emphasis + (1|submission_id) + (1|trial_number), data = dat)
# We judge there to be evidence in favor of the first hypothesis, if the p-value is less than 0,05.
summary(emp.clmm)
# p-value = 0.0268
AIC(emp.clmm)
# 2853

# Second hypothesis
# H0: There is no significant difference between auditory and written stimuli.
# H1: Auditory stimuli receive higher acceptability ratings than written stimuli.
# tested by linear mixed model
# as by this method:
mod.clmm = clmm(as.factor(response) ~ modality + (1|submission_id) + (1|trial_number), data = dat)
summary(mod.clmm)
# We judge there to be evidence in favor of the second hypothesis, if the p-value is less than 0,05.
# p-value = 0.0158
AIC(mod.clmm)
# 2852

# Third hypothesis
# H0: There is no significant difference between stimuli with lexical and functional fragments.
# H1: Stimuli with lexical fragments receive higher acceptability ratings than stimuli with functional fragments
# tested by linear mixed model
# as by this method:
frag.clmm = clmm(as.factor(response) ~ fragment_type + (1|submission_id) + (1|trial_number), data = dat)
summary(frag.clmm)
# We judge there to be evidence in favor of the third hypothesis, if the p-value is less than 0,05.
# p-value = 9.6e-05
AIC(frag.clmm)
# 2843

# model with all predictors
all.clmm = clmm(as.factor(response) ~ emphasis + modality + fragment_type + (1|submission_id) + (1|trial_number), data = dat)
summary(all.clmm)
# p-value = 9.02e-05
AIC(all.clmm)
# 2836


# -------------------- Model testing --------------------

# Model fit: Likelihood Ratio Test (compared to null model) 
# model with only the submission_id as predictor
null_model = clmm(as.factor(response) ~ 1 + (1|submission_id), data = dat)
summary(null_model)
AIC(null_model)
# 2864
# AIC of null model is higher

# testing whether the difference is significant
anova(null_model, all.clmm) 
# p-value = 2.445e-07
# yes, it is significant 
AIC(all.clmm)-AIC(null_model)
# -28
# There might be an effect that does not appear in the model, or predictors are rather weakly significant (except fragment_type)