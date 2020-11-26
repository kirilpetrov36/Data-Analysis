import pandas as pd
import seaborn as sb 
import matplotlib.pyplot as plt
import PySimpleGUI as ui
import plotly.express as px
import plotly.graph_objects as go
from numpy import ceil

path1 = 'E:/Everything/3 course/Data_analysis/Labs/2/covid19_by_area_type_hosp_dynamics.csv'
df = pd.read_csv(path1)
path2 = 'E:/Everything/3 course/Data_analysis/Labs/2/covid19_by_settlement_actual.csv'
coords = pd.read_csv(path2)
df['zvit_date'] = df['zvit_date'].astype('datetime64[ns]')
areas = df.registration_area.unique()
colors = ['mediumvioletred','royalblue', 'yellowgreen', 'darkorange','navy', 'blue', 'mediumpurple',  'maroon', 'darkorchid', 'plum', 'm', 'palevioletred',
          'coral',  'orange',  'lightgreen']
top10_index = list(coords.nlargest(11, ['total_confirm']).index)
del top10_index[9]

def show_plot(areas):
    if (len(areas) == 1 and areas[0] == 'Усі міста'):   
        columns = []   
        columns.append(pd.Series(df.groupby('zvit_date')['active_confirm'].sum()))
        columns.append(pd.Series(df.groupby('zvit_date')['new_susp'].sum()))
        columns.append(pd.Series(df.groupby('zvit_date')['new_confirm'].sum()))
        columns.append(pd.Series(df.groupby('zvit_date')['new_death'].sum()))
        columns.append(pd.Series(df.groupby('zvit_date')['new_recover'].sum()))
        dates = df.zvit_date.unique()
              
        for i in range(0, len(columns)):
            sb.lineplot(x = reversed(dates), y = columns[i], color=colors[i], label=columns[i].name)

    elif (len(areas) > 0):
        for i in range(0, len(areas)):
            columns = []
            columns.append(df[df["registration_area"] == areas[i]].groupby('zvit_date')['active_confirm'].sum())
            #columns.append(df[df["registration_area"] == areas[i]].groupby('zvit_date')['new_susp'].sum())
            #columns.append(df[df["registration_area"] == areas[i]].groupby('zvit_date')['new_confirm'].sum())
            #columns.append(df[df["registration_area"] == areas[i]].groupby('zvit_date')['new_death'].sum())
            #columns.append(df[df["registration_area"] == areas[i]].groupby('zvit_date')['new_recover'].sum())
            dates = df[df["registration_area"] == areas[i]].zvit_date.unique()
            print(columns)

            if (len(areas) != 1):
                for column in columns:
                    sb.lineplot(x = reversed(dates), y = column, color=colors[i], label=areas[i] + ' ' + column.name)   
            else:
                for j in range(0, len(columns)):
                    sb.lineplot(x = reversed(dates), y = columns[j], color=colors[j], label=areas[i] + ' ' + columns[j].name)

            columns.clear()
            
    fig = plt.gcf()

    # Change seaborn plot size
    fig.set_size_inches(12, 8)

    plt.show()
    

def map():
    max_confirm = coords['total_confirm'].max()
    min_confirm = coords['total_confirm'].min()
    filter = coords['registration_settlement'].index.isin(top10_index)
    scope = max_confirm - min_confirm
    f = go.Figure(data=go.Scattergeo(
        lon = coords['registration_settlement_lng'],
        lat = coords['registration_settlement_lat'],
        mode = 'markers+text', 
        text = coords['registration_settlement'].where(filter, ''),
        textfont = dict(size = 15),
        selectedpoints = top10_index,
        selected = dict(marker = dict(
            color = 'white',
            size = 12,
            opacity = 1
              )),
        marker = dict(
            size = 7,
            opacity = ((coords['total_confirm']-min_confirm)/scope)+(1-((coords['total_confirm']-min_confirm)/scope))/2,
            color = 'green'
        )))
    f.update_geos(fitbounds='locations')
    f.update_layout(height=600, margin={"r":0,"t":0,"l":0,"b":0})
    f.show()

def write_to_excel():
    gk = coords.groupby('registration_area')[['total_susp', 'total_confirm', 'total_death', 'total_recover']].sum()   
    print(gk.sort_values(by=['total_confirm']))
    gk.reset_index(inplace=True)
    gk.sort_values(by=['total_confirm']).to_excel(r'E:/Everything/3 course/Data_analysis/Labs/2/AreaAnalysis.xlsx', index = False)
    
layout = [[ui.Text('Choose area')], [ui.Button('Усі міста')],
                                    [ui.Button(areas[i]) for i in range(0, 5)],
                                    [ui.Button(areas[i]) for i in range(5, 10)],
                                    [ui.Button(areas[i]) for i in range(10, 15)],
                                    [ui.Button(areas[i]) for i in range(15, 20)],
                                    [ui.Button(areas[i]) for i in range(20, 25)],
                                    [ui.Button('Clear'), ui.Button('Start'), ui.Button('Map'), ui.Button('Write to file analysis')]]

window = ui.Window('Demo', layout)

choosen_areas = []
in_one_window = False

while True:
    event, values = window.read()
    if event in areas:
        choosen_areas.append(event)
    elif event == 'Усі міста':
        choosen_areas.append('Усі міста')    
    elif event == 'Start':
        show_plot(choosen_areas)
    elif event == 'Clear':
        choosen_areas.clear()
    elif event == 'Write to file analysis':
        write_to_excel()
    elif event == 'Map':
        map()
    else:
        break