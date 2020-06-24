# -*- coding: utf-8 -*-
"""
Created on Wed Jun 17 00:46:38 2020

@author: Sundara vel selvaraj
"""

import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.graph_objs as go

import pandas as pd
timesData=pd.read_csv("timesData.csv")

#imesData.info()

#timesData.head(5)

app = dash.Dash()

df2014=timesData[ timesData['year']==2014].iloc[:100,:]
df2015=timesData[ timesData['year']==2015].iloc[:100,:]
df2016=timesData[ timesData['year']==2016].iloc[:100,:]

trace1=go.Scatter(
                  x=df2014.world_rank,
                  y=df2014.citations,
                  mode="markers",
                  name="2014",
                  marker=dict( color='cyan'),
                  text=df2014.university_name )

trace2=go.Scatter(
                  x=df2015.world_rank,
                  y=df2015.citations,
                  mode="markers",
                  name="2015",
                  marker=dict( color='black'),
                  text=df2015.university_name )

trace3=go.Scatter(
                  x=df2016.world_rank,
                  y=df2016.citations,
                  mode="markers",
                  name="2016",
                  marker=dict( color='red'),
                  text=df2016.university_name )



df2016=timesData.iloc[:100,:]
trace4 = go.Scatter(
                    x = df2016.world_rank,
                    y = df2016.citations,
                    mode = "lines",
                    name = "citations",
                    marker = dict(color = 'darkred'),
                    text= df2016.university_name)
trace5 = go.Scatter(
                    x = df2016.world_rank,
                    y = df2016.teaching,
                    mode = "lines+markers",
                    name = "teaching",
                    marker = dict(color = 'seagreen'),
                    text= df2016.university_name)

df2015 = timesData[timesData.year == 2015].iloc[:5,:]

trace6 = go.Bar(
                x = df2015["university_name"],
                y = df2015["total_score"],
                name = "total_score",
                marker = dict(color = 'skyblue',
                             line=dict(color='rgb(0,0,0)',width=1.5)),
                text = df2015.country)
trace7 = go.Bar(
                x = df2015["university_name"],
                y = df2015["citations"],
                name = "citations",
                marker = dict(color = 'black',
                              line=dict(color='rgb(0,0,0)',width=1.5)),
                text = df2015.country)

df2011 = timesData[timesData["year"] == 2011].iloc[:100,:]
df2016 = timesData[timesData["year"] == 2012].iloc[:100,:]

trace8 = go.Histogram(
    x=df2011["country"],
    opacity=0.75,
    name = "2011",
    marker=dict(color='mediumaquamarine'))
trace9 = go.Histogram(
    x=df2016["country"],
    opacity=0.75,
    name = "2016",
    marker=dict(color='pink'))

df2016 = timesData[timesData.year == 2016].iloc[:7,:]
pie1 = df2016.num_students
pie1_list = [float(each.replace(',', '.')) for each in df2016.num_students]  # str(2,4) => str(2.4) = > float(2.4) = 2.4
labels = df2016.university_name

trace10=go.Pie(labels=labels, values=pie1_list,pull=[0,0,0, 0, 0, 0.2],hole=0.025)


df2016 = timesData[timesData.year == 2016].iloc[:20,:]
num_students_size  = [float(each.replace(',', '.')) for each in df2016.num_students]
international_color = [float(each) for each in df2016.international]

trace11=go.Scatter(
    x=df2016.world_rank,
    y=df2016.teaching,
    mode='markers',
    marker= {
            'color': international_color,
            'size': num_students_size,
            'showscale': True
        }, text=df2016.university_name
)

x2011 = timesData.student_staff_ratio[timesData.year == 2011]
x2012 = timesData.student_staff_ratio[timesData.year == 2012]

trace12 = go.Histogram(
    x=x2011,
    opacity=0.75,
    name = "2011",
    marker=dict(color='rgba(171, 50, 96, 0.6)'))
trace13 = go.Histogram(
    x=x2012,
    opacity=0.75,
    name = "2012",
    marker=dict(color='rgba(12, 50, 196, 0.6)'))


app.layout = html.Div([
    
    dcc.Graph(
        id='scatter plot',
        figure = {
            'data': [trace1,trace2,trace3],
            'layout': go.Layout(dict( title='Top 100 universities in 2014,2015 and 2016',
             xaxis=dict( title="World Rank",ticklen=5,zeroline=False ),
             yaxis=dict( title="Citation",ticklen=5,zeroline=False ),)
             )  
        }
    ),
    dcc.Graph(
        id='line plot',
        figure = {
            'data': [trace4, trace5],
            'layout': go.Layout(dict(title = 'Citation and Teaching vs World Rank of Top 100 Universities',
              xaxis= dict(title= 'World Rank',ticklen= 5,zeroline= False),
              yaxis= dict(title= 'Values',ticklen= 5,zeroline= False)
             )
            )
        }
    ),
    dcc.Graph(
        id='bar chart',
        figure = {
            'data': [trace6, trace7],
            'layout': go.Layout(barmode = "group",title = 'Top 5 universities in 2015')
        }
    ),
    dcc.Graph(
        id='bar plot',
        figure = {
            'data': [trace8, trace9],
            'layout': go.Layout(barmode='group',
                   title=' Number of universities in each countries in 2011 and 2016',
                   xaxis=dict(title='country'),
                   yaxis=dict( title='Count'),
             )
        }
    ),
    dcc.Graph(
        id='pie chart',
        figure = {
            'data': [trace10],
            'layout': go.Layout(title = 'Which US university has most number of students?')
        }
    ),
    dcc.Graph(
        id='bubble chart',
        figure = {
            'data': [trace11],
            'layout': go.Layout(title = 'Comparing University Student Size')
        }
    ),
    dcc.Graph(
        id='histogram',
        figure = {
            'data': [trace12,trace13],
            'layout': go.Layout(barmode='overlay',
                   title=' students-staff ratio in 2011 and 2012',
                   xaxis=dict(title='students-staff ratio'),
                   yaxis=dict( title='Count'))
        }
    )
    
]
)

if __name__ == '__main__':
    app.run_server(port=4051)

