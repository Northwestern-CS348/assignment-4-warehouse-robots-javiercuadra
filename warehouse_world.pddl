(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

  (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
  )

  (:action robotMove
      :parameters (?l0 - location ?l1 - location ?r - robot)
      :precondition (and (free ?r) (connected ?l0 ?l1) (at ?r ?l0) (no-robot ?l1) )
      :effect (and (at ?r ?l1) (no-robot ?l0) (not (at ?r ?l0)) (not (no-robot ?l1)) )
  )
  
  (:action robotMoveWithPallette
      :parameters (?l0 - location ?l1 - location ?r - robot ?p - pallette)
      :precondition (and (free ?r) (connected ?l0 ?l1) (at ?r ?l0) (at ?p ?l0) (no-robot ?l1) (no-pallette ?l1) )
      :effect (and (has ?r ?p) (at ?r ?l1) (at ?p ?l1) (no-robot ?l0) (no-pallette ?l0) (not (at ?r ?l0)) (not (at ?p ?l0)) (not (no-robot ?l1)) (not (no-pallette ?l1)) )
  )
  
  (:action moveItemFromPalleteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (ships ?s ?o) (orders ?o ?si) (started ?s) (packing-location ?l) (packing-at ?s ?l) (at ?p ?l) (contains ?p ?si) (not (complete ?s)))      
      :effect (and (includes ?s ?si) (not (contains ?p ?si)) )
  )
  
  (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (ships ?s ?o) (started ?s) (packing-location ?l) (packing-at ?s ?l) (not (complete ?s)) )
      :effect (and (complete ?s) (available ?l) (not (packing-at ?s ?l)) (not (started ?s)))
  )
)  
