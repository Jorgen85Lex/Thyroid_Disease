# Thyroid Disease

## Your in depth guide to understanding the risk of thyroid disease

[![Build Status](https://github.com/Jorgen85Lex/Thyroid_Disease.git)]

With this project we'll delve deeper into the human body, specifically looking at the thyroid, and gain a better grasp on thyroid disease. 

We'll look at sex, age, TSH/T3/T4/TT4/T4U/etc levels in the blood, and how those factors might indicate a specific diagnosis. 
>The data obtained to help guide us in our data journey is Thyroid Disease Data (Kaggle).
(https://www.kaggle.com/datasets/emmanuelfwerr/thyroid-disease-data).

## What is Thyroid Disease?
Thyroid disease is an umbrella term for conditions that affect how your thyroid functions. Hypothyroidism and hyperthyroidism are the two main types of thyroid disease. But they each have multiple possible causes. Thyroid diseases are treatable — usually with medication. 
> (https://my.clevelandclinic.org/health/diseases/8541-thyroid-disease)

- Most Common Types of Thyroid Disease are:
    -Hypothyroidism
    -Hyperthyroidism
        >T4 (thyroxine) is typically associated with hypothyroidism (an underactive thyroid), where the thyroid does not produce enough thyroid hormone. In this case, the thyroid produces insufficient amounts of both T3 and T4. Since T4 is the prohormone, it is usually converted into T3 in the body. A lack of T4 can result in sluggish metabolism, fatigue, weight gain, and other symptoms of hypothyroidism.
   
       T3 (triiodothyronine) is often associated with hyperthyroidism (an overactive thyroid), because in hyperthyroidism, the thyroid gland produces too much of both T3 and T4. T3 is the more active form of thyroid hormone and has a stronger effect on the body's metabolism. High levels of T3 can lead to symptoms like rapid heart rate, weight loss, and nervousness.

## Data Set Info 
on_thyroxine - whether patient is on thyroxine
on antithyroid meds - whether patient is on antithyroid meds 
sick - whether patient is sick
pregnant - whether patient is pregnant
thyroid_surgery - whether patient has undergone thyroid surgery 
I131_treatment - whether patient is undergoing I131(radioactive iodine) treatment 
lithium - whether patient * lithium
goitre - whether patient has goitre
tumor - whether patient has tumor
hypopituitary - whether patient * hyperpituitary gland
TSH - TSH level in blood from lab work
T3 - T3 level in blood from lab work
TT4 - TT4 level in blood from lab work
T4U - T4U level in blood from lab work
FTI - FTI level in blood from lab work
TBG - TBG level in blood from lab work
target - hyperthyroidism medical diagnosis
patient_id - unique id of the patient
Diagnosis - if a diagnosis was commented on(and what that is)
Condition(Type) - what that diagnosis categorizes as

    hyperthyroid conditions:

    A   hyperthyroid
    B   T3 toxic
    C   toxic goitre
    D   secondary toxic

    hypothyroid conditions:

    E   hypothyroid
    F   primary hypothyroid
    G   compensated hypothyroid
    H   secondary hypothyroid

    binding protein:

    I   increased binding protein
    J   decreased binding protein

    general health:

    K   concurrent non-thyroidal illness

    replacement therapy:

    L   consistent with replacement therapy
    M   underreplaced
    N   overreplaced

    antithyroid treatment:

    O   antithyroid drugs
    P   I131 treatment
    Q   surgery

    miscellaneous:

    R   discordant assay results
    S   elevated TBG
    T   elevated thyroid hormones