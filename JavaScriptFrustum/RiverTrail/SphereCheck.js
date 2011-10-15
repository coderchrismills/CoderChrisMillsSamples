var frustum = [
		new Float32Array([+1, 0, 0, 2]),
		new Float32Array([-1, 0, 0, 2]),
		new Float32Array([0, +1, 0, 2]),
		new Float32Array([0, -1, 0, 2]),
		new Float32Array([0, 0, +1, 2]),
		new Float32Array([0, 0, -1, 2])];

self.addEventListener('message', function(e) {
	var data = e.data;
	var spheres = data.spheres;
	var len = spheres.length;
	var vis = [];
	var nvis = 0;
	for (var i=0; i < len; i++) {
		var check = true;
		for (var k = 0; k < 6; k++) {
			if(check) {
				var d = (frustum[k])[0] * (spheres[i])[0] + (frustum[k])[1] * (spheres[i])[1] + (frustum[k])[2] * (spheres[i])[2] + (frustum[k])[3] + (spheres[i])[3];
				if(d > 0.0) {
					vis[nvis] = i;
					nvis++;
					check = false;
				}
			}
		}
	}
	self.postMessage(vis);
}, false);