;;;		* * * A muLISP CLOS Based Rocket and Particle System * * *

;;; This file is based on Appendix G of the book Common Lisp Programming
;;; for Artificial Intelligence by Tony Hasemer & John Dominigue.

;;; The purpose of this program is to demonstrate muLISP CLOS
;;; techniques by simulating the behavior of rockets and particles above
;;; the surface of an airless asteroid.  The hypothetical asteroid is
;;; airless, so there is no wind resistance.  However, it has gravity which
;;; pulls directly towards the asteroid's center from any point on or above
;;; its surface.  All distances, speeds and accelerations are measured in
;;; terms of horizontal and vertical components.

;;gravity - used to accelerate the rockets and particles - it does not
;;act in the horizontal direction but acts with a force of 4 units in the
;;vertical direction.
(setq *gravity* '(0 4))

;;the particle class, with default values for mass, position, speed, and
;;acceleration.  We also create accessor methods for reading and writing
;;slot values.
(defclass particle ()
   ((name :initform nil :initarg :name
	  :accessor name)			;particle name
    (mass  :initform 1) 			;particle mass
    (x-position :initform 0 :initarg :x-pos
		:accessor x-pos)		;x-coordinate of particle
    (y-position :initform 0 :initarg :y-pos
		:accessor y-pos)		;y-coordinate of particle
    (x-speed :initform 0 :initarg :x-spd
	     :accessor x-spd)			;speed along x axis
    (y-speed :initform 0 :initarg :y-spd
	     :accessor y-spd)			;speed along y axis
    (x-acceleration :initform (car *gravity*)
		    :accessor x-accel )        ;acceleration along x axis
    (y-acceleration :initform (cadr *gravity*)
		    :accessor y-accel )        ;acceleration along y axis
   ))

;;the rocket class.  Rockets are identical to particles, except
;;that rockets have motors.
(defclass rocket (particle)
   ((motor-force :initform '(0 0) :accessor motor-force)))

;;Returns the position of a particle as a list of its x and y
;;coordinates
(defgeneric position-of (particle))
(defmethod position-of ((p particle))
   (list (x-pos p) (y-pos p)))

;;Returns the velocity of a particle as a list of its x and y speeds
(defgeneric velocity-of (particle))
(defmethod velocity-of ((p particle))
   (list (x-spd p) (y-spd p)))

;;Returns the acceleration of a particle as a list of its x and y
;;acceleration
(defgeneric acceleration-of (particle))
(defmethod acceleration-of ((p particle))
   (list (x-accel p) (y-accel p)))

;;; Note that the only acceleration which any instance of PARTICLE can
;;; have is inherited: gravity is the only force acting on particles.
;;; Therefore there is no method to alter the acceleration of particles.
;;; Rockets, however, have motors and their accelerations can therefore
;;; change.

;;After the force of the motor is updated, make sure the rockets'
;;acceleration is updated also.
(defmethod setf-motor-force :after (force (r rocket))
  ;;the rockets acceleration is the vector sum of the force
  ;;of gravity AND the force of its motor
  (setf-x-accel (+ (CAR *gravity*) (CAR force)) r)
  (setf-y-accel (+ (CADR *gravity*) (CADR force)) r))

;;; In order to make the particles and rockets move, we need to invoke
;;; a function to move them.

;;Set the new position of a particle according to its current
;;velocity (assuming that only one unit of time has gone by)
(defgeneric new-position (particle))
(defmethod new-position ((p particle))
   (setf-x-pos (+ (x-pos p) (x-spd p)) p)
   (setf-y-pos (+ (y-pos p) (y-spd p)) p))

;;Set the new velocity of a particle according to its current
;;acceleration (assuming that only one unit of time has gone by)
(defgeneric new-velocity (particle))
(defmethod new-velocity ((p particle))
   (setf-x-spd (+ (x-spd p) (x-accel p)) p)
   (setf-y-spd (+ (y-spd p) (y-accel p)) p))

;;Prints the current status of a particle
(defgeneric status (object))
(defmethod status ((p particle))
   (fresh-line)
   (princ (pack* (name p) "'s report:"))
   (fresh-line)
   (princ "Position: ") (princ (position-of p))
   (princ " Velocity: ") (princ (velocity-of p))
   (princ " Acceleration: ") (princ (acceleration-of p)))

;;Additionally, print the motor force if the object is a rocket
(defmethod status :after ((r rocket))
   (princ " Motor force: ") (princ (motor-force r)))

;;the height of y = 0 above the asteroid
(setq *initial-height* 25)

;;the width of the asteroid
(setq *asteroid-width* 25)

;;Returns a nonNIL value if the particle has crashed into the surface
;;of the asteroid
(defgeneric crashed? (particle))
(defmethod crashed? ((p particle))
   (and (> (y-pos p) *initial-height*)
	(not (< (x-pos p) 0))
	(< (x-pos p) *asteroid-width*)))

;;Create-universe creates three particles and three rockets, sets the force
;;of each rocket's motor, and then cycles endlessly through the list of
;;instances, asking each one to report its status each time.  An additional
;;check is made each cycle to see if the instance has crashed into the surface
;;of the asteroid. After the status report on each cycle, the particles and
;;rockets are moved in preparation for the next cycle.	In this version
;;of create-universe P1, P2, R1 and R3 will crash into the asteroid and stop,
;;while P3 and R2 slip past into outer space.

(defun create-universe ()
  (let ((p1 (make-instance 'particle :name p1 :x-pos 4 :y-pos 3
					      :x-spd 2 :y-spd 5))
	(p2 (make-instance 'particle :name p2 :x-pos 0 :y-pos 0
					      :x-spd 0 :y-spd 1))
	(p3 (make-instance 'particle :name p3 :x-pos 1 :y-pos 1
					      :x-spd 9 :y-spd 4))
	(r1 (make-instance 'rocket   :name r1 :x-pos 2 :y-pos 3
					      :x-spd 4 :y-spd 3))
	(r2 (make-instance 'rocket   :name r2 :x-pos 7 :y-pos 5
					      :x-spd 2 :y-spd 1))
	(r3 (make-instance 'rocket   :name r3 :x-pos 3 :y-pos 4
					      :x-spd 4 :y-spd 2)))
   (setf-motor-force '(2 1) r1)
   (setf-motor-force '(7 6) r2)
   (setf-motor-force '(2 3) r3)
   (loop
      (dolist (obj (list p1 p2	p3 r1 r2 r3))
	 (status obj)
	 (cond ((crashed? obj)
		 (fresh-line)
		 (princ (pack* (name obj) " has crashed!")))
	       (t (new-position obj)
		  (new-velocity obj))))
       (terpri)
       (break nil "Type C to print next status of objects"))))

;;Use the form below to demo the system

(create-universe)

