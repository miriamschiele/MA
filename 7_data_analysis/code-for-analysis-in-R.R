# code for data analysis of study on fragments

# set up
library("tidyverse")
library("tidyr")
library("ggplot2")
library("Rmisc")
library("lme4")
library("lmerTest")
library("emmeans")
library("dplyr")
library("aida")

# read in data
all.dat <- read.csv("dat_pilot_study.csv", sep=";", header=TRUE) 

# information about participants 
# age
min(all.dat$age, na.rm=T)
# 24 in pilot study
max(all.dat$age, na.rm=T)
# 54 in pilot study
mean(all.dat$age, na.rm=T)
# 30.2 in pilot study

# gender
table(all.dat$gender)/56 #divided by 56 because every participants had 56 trials
# männlich  weiblich
# 2         4
# in pilot study

# education
table(all.dat$education) /56 #divided by 56 because every participants had 56 trials
# Abitur    Bachelor    kein Abitur 
# 2         3           1 
# in pilot study

nrow(all.dat)
# 336

# participants' comments on study
dat %>% pull(comments) %>% unique()

# data sorting and cleaning
# put all filler items in a seperate data set
fillerDat <- all.dat[all.dat$trial_type == "Filler",]
nrow(fillerDat)
# 168 in pilot study

# rename column in filler dataset to varying acceptabiltiy of filler stimuli (A-E)
colnames(fillerDat)[colnames(fillerDat) == "fragmentType_Acceptability"] = "acceptability"

# only use critical items for analysis
dat <- all.dat[all.dat$trial_type == "Critical",]
# rename column with fragment type 
colnames(dat)[colnames(dat) == "fragmentType_Acceptability"] = "fragment_type"
nrow(dat)
# 168 in pilot study
nrow(dat) == nrow(fillerDat)
# TRUE

# number of participants in each between-subject condition, i.e., written and auditory
table(all.dat$modality)  /56
# auditory  written 
# 2        4
# in pilot study


# -------------------- Data plotting --------------------

# plotting filler items with varying acceptability
fillerDat %>%
  ggplot(aes(x= acceptability, y = as.numeric(response))) +
  geom_boxplot (width =0.3) + 
  labs(title = "Perceived naturalness of filler items wth varying acceptability",
       x = "varying acceptability", y = "perceived naturalness") +
  scale_x_discrete(name = "acceptability", 
                       labels = c("A (full acceptablity)", "B (partial acceptability)", 
                                  "C (neutrality in terms of acceptability)", 
                                  "D (partial unacceptability)", "E (full unacceptability)"))+
  scale_y_continuous(breaks=c(1:7))

# emphasis
dat %>% 
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of stimuli with and wihtout emphasis",
       x = "emphasis", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:7))

# modality
dat %>% 
  ggplot(aes(x = modality, y = as.numeric(response), color = modality)) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of auditory and written stimuli",
       x = "modality", y = "perceived naturalness") +
  scale_y_continuous(breaks=c(1:7))

# fragment type
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  labs(title = "Perceived naturalness of functional and lexical fragments",
    x = "fragment type", y = "perceived naturalness") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical"))+
  scale_y_continuous(breaks=c(1:7))

# modality and emphasis in one graph
dat %>% 
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) +
  geom_jitter(height = 0) + 
  labs(title = "Auditory and written stimuli with and without emphasis",
       x = "emphasis", y = "perceived naturalness") +
  facet_wrap(~modality) +
  scale_y_continuous(breaks=c(1:7))

# emphasis and fragment type in one graph
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  labs(title = "Functional and lexical fragments with and without emphasis",
    x = "fragment type", y = "perceived naturalness", color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  facet_grid(~emphasis) +
  scale_y_continuous(breaks=c(1:7))

# modality and fragment type in one graph
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  labs(title = "Auditory and written stimuli with functional and lexical fragments",
    x = "fragment type", y = "perceived naturalness", color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                    labels = c("functional", "lexical")) +
  facet_grid(~modality) +
  scale_y_continuous(breaks=c(1:7))

# all factors in one graph
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  geom_jitter(height = 0) + 
  labs(title = "Participants' ratings of all critical items",
       x = "fragment type", y = "perceived naturalness", 
       color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  facet_grid(emphasis~modality) +
  scale_y_continuous(breaks=c(1:7))


# differences in responses depending on emphasis, modality, and fragment type
dat %>% 
  group_by(emphasis, modality, fragment_type) %>%
  summarize(mean = mean(as.numeric(response)),
            SD = sd(as.numeric(response)))

# including means and standard deviation

# emphasis
sumStatsEmp <- summarySE(dat, measurevar ="response", groupvars = "emphasis")

sumStatsEmp %>%
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) + 
  geom_point() +
  labs(y="percevied naturalness")+
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,7)

# modality
sumStatsMod <- summarySE(dat, measurevar ="response", groupvars = "modality")
sumStatsMod %>%
  ggplot(aes(x = modality, y = as.numeric(response), color = modality)) + 
  geom_point() +
  labs(y="percevied naturalness")+
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,7)

# fragment type
sumStatsFrag <- summarySE(dat, measurevar ="response", groupvars = "fragment_type")
sumStatsFrag %>%
  ggplot(aes(x = fragment_type, y = as.numeric(response), color = fragment_type)) + 
  geom_point() +
  labs(x="fragment type", y="percevied naturalness")+
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
  geom_errorbar(aes(ymin = as.numeric(response)-ci, 
                    ymax = as.numeric(response)+ci), width = 0.1)+
  ylim(1,7)

# all factors included
sumStats <- summarySE(dat, measurevar ="response", 
                      groupvars = c("emphasis", "modality", "fragment_type"))
sumStats$ci <- sumStatsEmp$ci 
#choosing one of the ci columns to ensure consistency when specifying ymin and ymax
sumStats %>%
  ggplot(aes(x= emphasis, y = as.numeric(response))) +
  geom_point() +
  geom_errorbar(aes(ymin = as.numeric(response) - ci, 
                    ymax = as.numeric(response) + ci), width = 0.1) +
  ylim(1, 7) +
  facet_grid(fragment_type ~ modality) 



# -------------------- Hypotheses testing --------------------

# z-score the responses
responses_z <- scale(as.numeric(dat$response))
dat$responses_z <- responses_z

# First hypothesis
# H0: There is no significant difference between stimuli with and without emphasis.
# H1: Stimuli with emphasis receive higher acceptability ratings than stimuli without emphasis.
# tested by linear mixed model
# as by this method:
modelemp <- lmer(data = dat, responses_z ~ emphasis + (1|submission_id))
summary(modelemp)
# p value = 0.268 in pilot study
# We judge there to be evidence in favor of the first hypothesis, if the p-value is less than 0,05.

# Second hypothesis
# H0: There is no significant difference between auditory and written stimuli.
# H1: Auditory stimuli receive higher acceptability ratings than written stimuli.
# tested by linear mixed model
# as by this method:
modelmod <- lmer(data=dat, responses_z ~ modality + (1|submission_id))
summary(modelmod)
# p value = 0.654 in pilot study
# We judge there to be evidence in favor of the second hypothesis, if the p-value is less than 0,05.

# Third hypothesis
# H0: There is no significant difference between stimuli with lexical and functional fragments.
# H1: Stimuli with lexical fragments receive higher acceptability ratings than stimuli with functional fragments
# tested by linear mixed model
# as by this method:
modelfrag <- lmer(data=dat, responses_z ~ fragment_type + (1|submission_id))
summary(modelfrag)
# p value = 0.13 in pilot study
# We judge there to be evidence in favor of the third hypothesis, if the p-value is less than 0,05.