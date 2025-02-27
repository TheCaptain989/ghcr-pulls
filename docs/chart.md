---
layout: default
---
<div style="width: 700px;"><canvas id="GHCR"></canvas></div>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
async function loadJSON(url) {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`Response status: ${response.status}`);
  }

  const data = await response.json();
  console.log(data.tag);
  myChart.data.datasets.forEach((dataset) => {
  	dataset.label.push(data.tag);
    dataset.data.push(data.raw_pulls_all);
  });
  myChart.update();
  /*new Chart(objChart, {
	type: 'line',
  	data: {
	    datasets: [{
      	label: data.tag,
        data: data.raw_pulls_all
      }]
	  }
	});*/
}

const objChart = document.getElementById('GHCR');
new myChart(objChart, {
	type: 'line',
  data: {
  	datasets: []
  }
});

const url1 = "./radarr-striptracks.json";
//const url2 = "./lidarr-flac2mp3.json";
loadJSON(url1);
//loadJSON(url2);
</script>