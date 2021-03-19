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
      text: 'No. of Umpires By Country'
    },
    subtitle: {
      text: 'Source: <a href="https://en.wikipedia.org/wiki/List_of_Indian_Premier_League_umpires#:~:text=29%20of%20the%20umpires%20are,of%20West%20Indies%20and%20Zimbabwe.">Wikipedia</a>'
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
        text: 'No of Umpire'
      }
    },
    legend: {
      enabled: false
    },
    tooltip: {
      pointFormat: 'No. of Umpires: <b>{point.y} </b>'
    },
    series: [{
      name: 'Population',
      data: data.umpires_by_country,
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