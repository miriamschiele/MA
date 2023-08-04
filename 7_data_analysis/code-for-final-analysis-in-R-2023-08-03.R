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
library("pwr")
library("aida")
library("ordinal")

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

# data sorting and cleaning

# put all filler items in a separate data set
fillerDat <- all.dat[all.dat$trial_type == "Filler",]

# rename column in filler dataset to varying acceptability of filler stimuli (A-E)
colnames(fillerDat)[colnames(fillerDat) == "fragmentType_Acceptability"] = "acceptability"

# only use critical items for analysis
dat <- all.dat[all.dat$trial_type == "Critical",]
# rename column with fragment type 
colnames(dat)[colnames(dat) == "fragmentType_Acceptability"] = "fragment_type"

nrow(dat) == nrow(fillerDat)
# TRUE

# -------------------- Data plotting --------------------

# emphasis
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
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical"))+
  scale_y_continuous(breaks=c(1:7))

# modality and emphasis in one graph
dat %>% 
  ggplot(aes(x = emphasis, y = as.numeric(response), color = emphasis)) +
  geom_jitter(height = 0) + 
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  labs(title = "Auditory and written stimuli with and without emphasis",
       x = "emphasis", y = "perceived naturalness") +
  facet_wrap(~modality) +
  scale_y_continuous(breaks=c(1:7))

# emphasis and fragment type in one graph
dat %>% 
  ggplot(aes(x = fragment_type, y = as.numeric(response), 
             color = fragment_type)) +
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
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
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
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
  theme(axis.text=element_text(size=16),
        axis.title=element_text(size=16), 
        plot.title = element_text(size = 20))+
  guides(color = guide_legend(override.aes = list(size = 10))) +
  labs(title = "Participants' ratings of all critical items",
       x = "fragment type", y = "perceived naturalness", 
       color = "fragment type") +
  scale_x_discrete(labels=c("functional", "lexical")) +
  scale_color_discrete(name = "fragment type", 
                       labels = c("functional", "lexical")) +
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
  labs(y="percevied naturalness", x="fragment type") +
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
# p value = 0.0.00709
# We judge there to be evidence in favor of the first hypothesis, if the p-value is less than 0,05.

# Second hypothesis
# H0: There is no significant difference between auditory and written stimuli.
# H1: Auditory stimuli receive higher acceptability ratings than written stimuli.
# tested by linear mixed model
# as by this method:
modelmod <- lmer(data=dat, responses_z ~ modality + (1|submission_id))
summary(modelmod)
# p value = 0.00202
# We judge there to be evidence in favor of the second hypothesis, if the p-value is less than 0,05.

# Third hypothesis
# H0: There is no significant difference between stimuli with lexical and functional fragments.
# H1: Stimuli with lexical fragments receive higher acceptability ratings than stimuli with functional fragments
# tested by linear mixed model
# as by this method:
modelfrag <- lmer(data=dat, responses_z ~ fragment_type + (1|submission_id))
summary(modelfrag)
# p value = 0.00178
# We judge there to be evidence in favor of the third hypothesis, if the p-value is less than 0,05.

dat_all = lmer(data=dat, responses_z ~ fragment_type + modality + emphasis + (1|submission_id))
summary(dat_all)


# --------------- CLMM

mosaicplot(dat$response ~ dat$emphasis, xlab = "perceived naturalness", ylab = "emphasis", color = TRUE)
emp.clmm = clmm(as.factor(response) ~ emphasis + (1|submission_id), data = dat)
summary(emp.clmm)
AIC(emp.clmm)
# 2862

mosaicplot(dat$response ~ dat$modality, xlab = "perceived naturalness", ylab = "modality", color = TRUE)
mod.clmm = clmm(as.factor(response) ~ modality + (1|submission_id), data = dat)
summary(mod.clmm)
AIC(mod.clmm)
# 2860

mosaicplot(dat$response ~ dat$fragment_type, xlab = "perceived naturalness", ylab = "fragment type", color = TRUE)
frag.clmm = clmm(as.factor(response) ~ fragment_type + (1|submission_id), data = dat)
summary(frag.clmm)
AIC(frag.clmm)
# 2853

# model with all predictors
all.clmm = clmm(as.factor(response) ~ emphasis + modality + fragment_type + (1|submission_id), data = dat)
summary(all.clmm)
AIC(all.clmm)
# 2847 

# Model fit: Likelihood Ratio Test (compare with null model) 
null_model = clmm(as.factor(response) ~ 1 + (1|submission_id), data = dat)
summary(null_model)
AIC(null_model)
# 2864
# das null model ist im prinzip ein model, dass nur einen random factor nimmt und 
# alle anderen predictor 'nicht existieren', d.h. so würde das Model ohne predictor aussehen (lediglich submission_id) 

anova(null_model, all.clmm) # tested ob Unterschied significant ist 
# ja, 3.018e-05 *** 
AIC(all.clmm)-AIC(null_model)
# AIC geht aber nur um 17 Punkte runter 
# -> es könnte also einen Effekt geben, der nicht in dem Model auftaucht, bzw.  Predictor sind eher schwach signifikant (außer fragment_type)



# ------ Zusatz 
# adding predictors (das kannst du im Prinzip auslassen, weil alle bei alpha 0.05 significant sind)
dat1.clmm = clmm(as.factor(response) ~ emphasis + modality + (1|submission_id), data = dat)
summary(dat1.clmm)
AIC(dat1.clmm)
# 2858 

dat2.clmm = clmm(as.factor(response) ~ emphasis + fragment_type + (1|submission_id), data = dat)
summary(dat2.clmm)
AIC(dat2.clmm)
# 2852 

dat3.clmm = clmm(as.factor(response) ~ modality + fragment_type + (1|submission_id), data = dat)
summary(dat3.clmm)
AIC(dat3.clmm)
# 2849 
# die ganzen Steps davor muss man nicht machen, ich wollte dir damit nur zeigen, 
# dass sich der AIC nur leicht verändert und der Unterschied zwischen model mit 
# allen predictor nur slightly besser ist als das model mit modality + fragment_type (siehe unten)

# du kannst natürlich alle drei predictor behalten oder gucken wie es ohne emphasis aussieht 
anova(all.clmm, dat3.clmm) 
# Unterschied zwischen den beiden ist nur schwach signifikant 0.03683 * 
anova(dat3.clmm, null_model)
#  6.611e-05 ***, stark signifikant zu null model -> musst du wissen, ob emphasis für dich ein significanter predictor ist 

