var wwCuller = {};
WWCuller = function(size, rep, numww) {
	this.pos                    = new Array(size);
	this.res                    = new Array(size);
	this.queue                  = new Array(numww);
	this.iter                   = rep;
	this.numWebWorkers          = numww;
	this.numWebWorkersRunning   = 0;
    
	for (var i=0; i<numww; i++) {
		this.queue[i] = new Worker("SphereCheck.js");
        this.queue[i].onmessage = function(event) {
            wwCuller.numWebWorkersRunning--;
			if(wwCuller.numWebWorkersRunning <= 0) {
                wwCuller.cullTest();   
            }
		};
	}
	
	for (var i=0; i<this.pos.length; i++) {
		this.pos[i] = new Float32Array([Math.random()*2,Math.random()*2,Math.random()*2,1]);
		this.res[i] = 0;
	}
};

WWCuller.prototype.doCullIteration = function() {
	var len = this.pos.length;
	var numww = this.numWebWorkers;
	var step = Math.floor(len/numww);
    var count = 0;
	for(var i=0; i<len; i+=step) {
        this.numWebWorkersRunning++;
		var data_slice = this.pos.slice(i*step, (i+1)*step-1);
        this.queue[count].postMessage({'spheres':data_slice});
        count++;
	}
};

WWCuller.prototype.finished = function() { };

WWCuller.prototype.cullTest = function() {
	var iter = this.iter;
	if(iter >= 0) {
		this.iter--;
		this.doCullIteration();
	}
	else {
		this.finished();
	}
};
