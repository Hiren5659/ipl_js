!async function(){
    let data = await fetch("../test.json")
       .then((response) => response.json())
       .then(data => {
           return data;
       })
       .catch(error => {
           console.error(error);
       })
    
    

Highcharts.chart('container', {
    chart: {
      type: 'column'
    },
    title: {
      text: 'Total Run By Teams'
    },
    subtitle: {
      text: 'Source: kaggle.com'
    },
    xAxis: {
      categories: [
        '2008',
        '2009',
        '2010',
        '2011',
        '2012',
        '2013',
        '2014',
        '2015',
        '2016',
        '2017',
      ],
      crosshair: true
    },
    yAxis: {
      min: 0,
      title: {
        text: 'No. of matches'
      }
    },
    tooltip: {
      headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
      pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
        '<td style="padding:0"><b>{point.y}</b></td></tr>',
      footerFormat: '</table>',
      shared: true,
      useHTML: true
    },
    plotOptions: {
      column: {
        pointPadding: 0.2,
        borderWidth: 0
      }
    },
    series: data.matches_by_team_per_season 
   
})
}();