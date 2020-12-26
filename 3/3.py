import numpy as np
import pandas as pd
from asq import query
import sklearn.linear_model as lm
from sklearn import preprocessing
import matplotlib.pyplot as plt
import seaborn as sb
from pylab import show
from sklearn.metrics import r2_score

path1 = 'E:/Everything/3 course/Data_analysis/Labs/3/covid19_by_area_type_hosp_dynamics.csv'

raw = pd.read_csv(path1, parse_dates=["zvit_date"])

4 6 8 10 12
2 4 6 8 10

A = [
    'Івано-Франківська', #0
    'Волинська', #1
    'Вінницька', #2
    'Дніпропетровська', #3
    'Донецька', #4
    'Житомирська', #5
    'Закарпатська', #6
    'Запорізька', #7
    'Київська', #8
    'Кіровоградська', #9
    'Луганська', #10
    'Львівська', #11
    'Миколаївська', #12
    'Одеська', #13
    'Полтавська', #14
    'Рівненська', #15
    'Сумська', #16
    'Тернопільська', #17
    'Харківська', #18
    'Херсонська', #19
    'Хмельницька', #20
    'Черкаська', #21
    'Чернівецька', #22
    'Чернігівська', #23
    'м. Київ'] #24
lA = len(A)

for i in range(len(A)):
    print(A[i], ' - ', i)

DF = query(A).select(lambda area: raw.query(
    f'registration_area == "{area}"').groupby('zvit_date').sum()).to_list()

minDF = query(DF).select(lambda x: len(x)).min()

DF = query(DF).select(lambda x: x[len(x)-minDF:len(x)]).to_list()

Ar = pd.DataFrame(np.zeros((25, 25)))

for i in range(25):
    d1 = DF[i].active_confirm
    for j in range(i, 25):
        d2 = DF[j].active_confirm
        Ar[i][j] = Ar[j][i] = d1.corr(d2)
                                                                        
def lag(sq1, sq2, T):
    maxLag = (0, 0)
    for i in range(-T, T+1):
        if (i < 0 ):
            rs = sq1.iloc[:(len(sq2)+i)].corr(sq2.shift(i).iloc[:(len(sq2)+i)])
        elif (i > 0):
            rs = sq1.iloc[i+1:].corr(sq2.shift(i).iloc[i+1:])
        else:
            rs = sq1.corr(sq2.shift(i))
        if rs > maxLag[0]:
            maxLag = (rs, i)
    return maxLag

Tr = pd.DataFrame(np.eye(lA))  # max corrrelation
Tl = pd.DataFrame(np.eye(lA))  # max lag

for i in range(lA):
    for j in range(i, lA):
        if(i != j):
            Tr[i][j], Tl[i][j] = lag(DF[i].active_confirm, DF[j].active_confirm, 50)
            Tr[j][i] = Tr[i][j]
            Tl[j][i] = Tl[i][j]*(-1)

print('Кореляція кількості активних хворих в різних областях ') 
sb.heatmap(Ar)
show()
#Ar.to_excel(r'E:/Everything/3 course/Data_analysis/Labs/3/Correlation.xlsx', index = False)

print('Найбільший коефіцієнт кореляції між областями')
sb.heatmap(Tr)
show()
#Tr.to_excel(r'E:/Everything/3 course/Data_analysis/Labs/3/LagCorrelation.xlsx', index = False)

print('Лаг') 
sb.heatmap(Tl)
show()
#Tl.to_excel(r'E:/Everything/3 course/Data_analysis/Labs/3/Lags.xlsx', index = False)

lengths = []
for i in range(len(Tl)):
    lengths.append(Tl[i].sum())

len_n = np.array(lengths)
#len_n = len_n.argsort()[-3:][::-1]
len_n = np.argpartition(len_n, 3)
for i in range(len(len_n)):
    print(A[len_n[i]])

def count_score (n):
    temp_lag = int(Tl[8][n])*(-1)
    skm = lm.LinearRegression()
    if temp_lag >= 0: 
        x = np.array(DF[8].active_confirm.shift(temp_lag).iloc[temp_lag+1:240]).reshape(-1, 1)
        y = DF[n].active_confirm.iloc[temp_lag+1:240]
    else:
        x = np.array(DF[8].active_confirm.shift(temp_lag).iloc[0:240-temp_lag*(-1)]).reshape(-1, 1)
        y = DF[n].active_confirm.iloc[0:240-temp_lag*(-1)]
    skm.fit(x, y)

    y_predicted = skm.predict(x)
    score2 = r2_score(y_predicted, y)

    return score2

def train (n):
    temp_lag = int(Tl[8][n])*(-1)
    skm = lm.LinearRegression()
    if temp_lag >= 0: 
        x = np.array(DF[8].active_confirm.shift(temp_lag).iloc[temp_lag+1:250]).reshape(-1, 1)
        y = DF[n].active_confirm.iloc[temp_lag+1:250]
    else:
        x = np.array(DF[8].active_confirm.shift(temp_lag).iloc[0:250-temp_lag*(-1)]).reshape(-1, 1)
        y = DF[n].active_confirm.iloc[0:250-temp_lag*(-1)]
    skm.fit(x, y)

    y_predicted = skm.predict(x)
    print('predicted =', y_predicted[len(y_predicted)-9:len(y_predicted)])
    print('actual', DF[n].active_confirm.iloc[241:250])

    sb.lineplot(x = DF[n].index[0:250], y = DF[n].active_confirm.iloc[0:250], label = "Actual data")
    sb.lineplot(x = DF[n].index[241:250], y = y_predicted[len(y_predicted)-9:len(y_predicted)], label = "Prognosed data").set_title(A[n])
    plt.xticks(rotation=30)
    plt.show()

def Mtrain (area):
    lag_area1 = int(Tl[area1][area])*(-1)
    lag_area2 = int(Tl[area2][area])*(-1)
    lag_area3 = int(Tl[area3][area])*(-1)  
    lags = [lag_area1, lag_area2, lag_area3] 
    p_lags = [elem for elem in lags if elem >= 0]
    m_lags = [elem for elem in lags if elem < 0] 
    p_lags.append(0)
    m_lags.append(0)
    lag_max = max(p_lags)
    lag_min = min(m_lags)

    x1 = DF[area1].active_confirm.shift(lag_area1).iloc[lag_max+1:250-lag_min*(-1)]
    x2 = DF[area2].active_confirm.shift(lag_area2).iloc[lag_max+1:250-lag_min*(-1)]
    x3 = DF[area3].active_confirm.shift(lag_area3).iloc[lag_max+1:250-lag_min*(-1)]
    y = DF[area].active_confirm.iloc[lag_max+1:250-lag_min*(-1)]
    

    x = pd.concat([x1, x2, x3], axis=1, sort=False)
    skm = lm.LinearRegression()
    skm.fit(x, y)
    y_predicted = skm.predict(x)

    sb.lineplot(x = DF[area].index[0:250], y = DF[area].active_confirm.iloc[0:250], label = "Actual data")
    sb.lineplot(x = DF[area].index[241:250], y = y_predicted[len(y_predicted)-9:len(y_predicted)], label = "Prognosed data").set_title(A[area])
    plt.xticks(rotation=30)
    plt.show()

area1 = len_n[0]
area2 = len_n[1]
area3 = len_n[2]


def count_Mscore(area):
    lag_area1 = int(Tl[area1][area])*(-1)
    lag_area2 = int(Tl[area2][area])*(-1)
    lag_area3 = int(Tl[area3][area])*(-1)  
    lags = [lag_area1, lag_area2, lag_area3] 
    p_lags = [elem for elem in lags if elem >= 0]
    m_lags = [elem for elem in lags if elem < 0] 
    p_lags.append(0)
    m_lags.append(0)
    lag_max = max(p_lags)
    lag_min = min(m_lags)

    x1 = DF[area1].active_confirm.shift(lag_area1).iloc[lag_max+1:240-lag_min*(-1)]
    x2 = DF[area2].active_confirm.shift(lag_area2).iloc[lag_max+1:240-lag_min*(-1)]
    x3 = DF[area3].active_confirm.shift(lag_area3).iloc[lag_max+1:240-lag_min*(-1)]
    y = DF[area].active_confirm.iloc[lag_max+1:240-lag_min*(-1)]

    x = pd.concat([x1, x2, x3], axis=1, sort=False)
    skm = lm.LinearRegression()
    skm.fit(x, y)
    y_predicted = skm.predict(x)
    score2 = r2_score(y_predicted, y)
    return score2

# main   
endOfProgram = True
while(endOfProgram):
    print('Auto count ? :')
    use_leader = int(input())
    if (use_leader == 1):
        print('How many leaders to use: ')
        leaders_amount = int(input())
        if (leaders_amount == 1):
            scores = [count_score(i) for i in range(len(A))]
            scores[8] = 0
            lead = scores.index(max(scores))
            train(lead)

        elif (leaders_amount == 3):
            scores = [count_Mscore(i) for i in range(len(A))]
            scores[8] = 0
            lead = scores.index(max(scores))
            Mtrain(lead)
                
        else:
            endOfProgram = False
    elif (use_leader == 0):
        print('How many leaders to use: ')
        leaders_amount = int(input())
        if (leaders_amount == 1):
            print('Choose area: ')
            area = int(input())
            train(area)
        elif (leaders_amount == 3):
            print('Choose area: ')
            area = int(input())
            Mtrain(area)                
        else:
            endOfProgram = False
    else:
        endOfProgram = False
