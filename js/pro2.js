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
      text: 'Top 5 batsman for RCB'
    },
    subtitle: {
      text: 'Source: kaggle.com'
    },
    xAxis: {
      type: 'category',
      labels: {
        rotation: -45,
        style: {
          fontSize: '13px',
          fontFamily: 'Verdana, sans-serif'
        }
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'Runs'
      }
    },
    legend: {
      enabled: false
    },
    tooltip: {
      pointFormat: '<b>{point.y} Runs</b>'
    },
    series: [{
      name: 'Population',
      data: data.top5_rcb_batsman,
      dataLabels: {
        enabled: true,
        rotation: -90,
        color: '#FFFFFF',
        align: 'right',
        y: 10, // 10 pixels down from the top
        style: {
          fontSize: '13px',
          fontFamily: 'Verdana, sans-serif'
        }
      }
    }]
  });}();