async function loadJSON(url) {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`Response status: ${response.status}`);
    }
  
    const data = await response.json();
    //console.log(data.tag);
    return data;
}
  
const objChart = document.getElementById('GHCR');
const myChart = new Chart(objChart, {
    type: 'line',
    data: {
        datasets: []
    }
});

async function updateChart() {
    const urls = ["https://thecaptain989.github.io/ghcr-pulls/radarr-striptracks.json", "https://thecaptain989.github.io/ghcr-pulls/lidarr-flac2mp3.json"];
    for (const url of urls) {
        const data = await loadJSON(url);
        myChart.data.datasets.push({
          label: data.tag,
          data: data.raw_pulls_all
        });
    }
    myChart.update();
}

updateChart();