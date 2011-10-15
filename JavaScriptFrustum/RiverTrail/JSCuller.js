(function() {
	JSCuller = function(size) {
		this.pos = new Array(size);
		this.res = new Array(size);
		for (var i=0; i<this.pos.length; i++) {
			this.pos[i] = new Float32Array([Math.random()*2,Math.random()*2,Math.random()*2,1]);
			this.res[i] = 0;
		}
	}

	var frustum = [
		new Float32Array([+1, 0, 0, 2]),
		new Float32Array([-1, 0, 0, 2]),
		new Float32Array([0, +1, 0, 2]),
		new Float32Array([0, -1, 0, 2]),
		new Float32Array([0, 0, +1, 2]),
		new Float32Array([0, 0, -1, 2])];

	var sphereCheck = function(pt) {
		for (var i = 0; i < 6; i++) {
			var d = frustum[i][0] * pt[0] + frustum[i][1] * pt[1] + frustum[i][2] * pt[2] + (frustum[i][3] + pt[3]);
			if (d < 0)
				return false;
		}
		return true;
	}

	JSCuller.prototype.cullTest = function(iter) {
		var start = Date.now();
		var len = this.pos.length;
		for (var j=0; j<iter; j++) {
			var nvis = 0;
			for (var i=0; i<len; i++) {
				if (sphereCheck(this.pos[i])) {
					this.res[nvis] = i;
					nvis++;
				}
			}
		}
		var end = Date.now();
		return (end - start);
	}
})();