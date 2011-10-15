(function() {
	WebWorkerCuller = function(size) {
		var initPos = new Array(size);
		var initRes = new Array(size);

		for (var i=0; i<initPos.length; i++) {
			initPos[i] = new Float32Array([Math.random()*2, Math.random()*2, Math.random()*2, 1]);
			initRes[i] = 0.0;
		}

		this.pos = new Float32Array(initPos);
		this.res = new Float32Array(initRes);

		this.frustum = [
			new Float32Array([+1, 0, 0, 2]),
			new Float32Array([-1, 0, 0, 2]),
			new Float32Array([0, +1, 0, 2]),
			new Float32Array([0, -1, 0, 2]),
			new Float32Array([0, 0, +1, 2]),
			new Float32Array([0, 0, -1, 2])
		];
	}	

	function cullingfunction(index, fr0, fr1, fr2, fr3, fr4, fr5, dt) 
	{
		var dp0 = 	fr0.get(0) * this.get(index).get(0) +
					fr0.get(1) * this.get(index).get(1) +
					fr0.get(2) * this.get(index).get(2) +
					fr0.get(3) + this.get(index).get(3);
		if (dp0 < 0.0)
			return 0.0;

		var dp1 = 	fr1.get(0) * this.get(index).get(0) +
					fr1.get(1) * this.get(index).get(1) +
					fr1.get(2) * this.get(index).get(2) +
					fr1.get(3) + this.get(index).get(3);
		if (dp1 < 0.0)
			return 0.0;

		var dp2 = 	fr2.get(0) * this.get(index).get(0) +
					fr2.get(1) * this.get(index).get(1) +
					fr2.get(2) * this.get(index).get(2) +
					fr2.get(3) + this.get(index).get(3);
		if (dp2 < 0.0)
			return 0.0;

		var dp3 = 	fr3.get(0) * this.get(index).get(0) +
					fr3.get(1) * this.get(index).get(1) +
					fr3.get(2) * this.get(index).get(2) +
					fr3.get(3) + this.get(index).get(3);
		if (dp3 < 0.0)
			return 0.0;

		var dp4 = 	fr4.get(0) * this.get(index).get(0) +
					fr4.get(1) * this.get(index).get(1) +
					fr4.get(2) * this.get(index).get(2) +
					fr4.get(3) + this.get(index).get(3);
		if (dp4 < 0.0)
			return 0.0;

		var dp5 = 	fr5.get(0) * this.get(index).get(0) +
					fr5.get(1) * this.get(index).get(1) +
					fr5.get(2) * this.get(index).get(2) +
					fr5.get(3) + this.get(index).get(3);
		if (dp5 < 0.0)
			return 0.0;
		
	}

	WebWorkerCuller.prototype.cullTest = function(iter) {
		var start = Date.now();
		for (var j=0; j<iter; j++) {
			this.res = this.pos.combine(1, low_precision(cullingfunction),
				this.frustum[0], this.frustum[1], this.frustum[2], this.frustum[3],
				this.frustum[4], this.frustum[5], 1/30);
		}
		var end = Date.now();
		return (end - start);
	};
})();