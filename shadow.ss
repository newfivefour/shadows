#lang racket
(require readline)

;; basics

(define (atom? a)
  (or (symbol? a) (number? a)))

(define (lat? lat)
  (cond
    ((null? lat) #t)
    ((atom? (car lat)) (lat? (cdr lat)))
    (else #f)))

(define (length lat)
    (cond
      ((null? lat) 0)
      (else (add1 (length (cdr lat))))))

(define (pick lat n)
  (cond ((one? n) (car lat))
        (else (pick (cdr lat) (sub1 n)))))

(define (rempick lat n)
  (cond ((one? n) (cdr lat))
        (else (cons
               (car lat)
               (rempick (cdr lat) (sub1 n))))))

(define (member? lat a)
  (cond ((null? lat) #f)
        (else (or
               (eq? (car lat) a)
               (member? (cdr lat) a)))))

(define (rember lat a)
  (cond ((null? lat) '())
        ((eq? (car lat) a) (cdr lat))
        (else (cons
               (car lat)
               (rember (cdr lat) a)))))

(define (firsts lat)
  (cond ((null? lat) '())
        (else
         (cons
          (car (car lat))
          (firsts (cdr lat))))))

(define (insertR lat old new)
  (cond ((null? lat) '())
        ((eq? (car lat) old)
         (cons
          old
          (cons
           new
           (insertR (cdr lat) old new))))
        (else (cons (car lat) (insertR (cdr lat) old new)))))


(define (insertL lat old new)
  (cond ((null? lat) '())
        ((eq? (car lat) old)
         (cons
          new
          (cons
           old
           (insertL (cdr lat) old new))))
        (else (cons (car lat) (insertL (cdr lat) old new)))))

(define (subst lat old new)
  (cond ((null? lat) '())
        ((eq? (car lat) old)
         (cons
          new
          (subst (cdr lat) old new)))
        (else (cons (car lat) (subst (cdr lat) old new)))))

(define (subst2 lat old1 old2 new)
  (cond ((null? lat) '())
        ((or (eq? old1 (car lat)) (eq? old2 (car lat)))
         (cons new (subst2 (cdr lat) old1 old2 new)))
        (else (cons (car lat) (subst2 (cdr lat) old1 old2 new)))))


(define (occur lat a)
  (cond ((null? lat) 0)
        ((eq? (car lat) a) (add1 (occur (cdr lat) a)))
        (else (occur (cdr lat) a))))

;; numbers

(define (+ x y)
    (cond ((zero? y) x)
          (else (add1 (+ x (sub1 y))))))

(define (- x y)
  (cond ((zero? y) x)
        (else (sub1 (- x (sub1 y))))))

(define (x x1 y)
  (cond ((zero? y) 0)
        (else (+ x1 (x x1 (sub1 y))))))

(define (> x y)
  (cond ((zero? x) #f)
        ((zero? y) #t)
        (else (> (sub1 x) (sub1 y)))))

(define (< x y)
  (cond ((zero? y) #f)
        ((zero? x) #t)
        (else (< (sub1 x) (sub1 y)))))

(define (= x y)
  (cond ((< x y) #f)
        ((> x y) #f)
        (else #t)))

(define (equan? x y)
  (cond ((and (number? x) (number? y)) (= x y))
        ((and (symbol? x) (symbol? y)) (eq? x y))
        (else #f)))

(define (% x y)
  (cond ((= x y) 1)
        ((< x y) 0)
        (else (add1 (% (- x y) y)))))
        
(define (^ x1 y)
  (cond ((zero? y) 1)
        (else (x x1 (^ x1 (sub1 y))))))

(define (powerlist_ x y)
  (cond ((zero? y) '())
        (else
         (cons (^ x y)
               (powerlist_ x (sub1 y))))))

(define (powerlist x y) (reverse (powerlist_ x y)))

(define (addtup tup)
  (cond ((null? tup) 0)
        (else (+ (car tup) (addtup (cdr tup))))))

(define (tup+ t1 t2)
  (cond
    ((null? t1) t2)
    ((null? t2) t1)
    (else (cons
           (+ (car t1) (car t2))
           (tup+ (cdr t1) (cdr t2))))))

(define (no-nums lat)
  (cond ((null? lat) '())
        ((number? (car lat)) (no-nums (cdr lat)))
        (else (cons
               (car lat)
               (no-nums (cdr lat))))))

(define (all-nums lat)
  (cond ((null? lat) '())
        ((number? (car lat)) (cons
                              (car lat)
                              (all-nums (cdr lat))))
        (else (all-nums (cdr lat)))))

(define (one? x)
  (= x 1))

(define (leftmost lat)
  (cond ((null? lat) '())
        ((symbol? (car lat)) (car lat))
        (else (leftmost (car lat)))))

;; list recursive

(define (rember* lat a)
  (cond ((null? lat) '())
        ((symbol? (car lat))
         (cond ((eq? (car lat) a) (rember* (cdr lat) a))
               (else (cons (car lat) (rember* (cdr lat) a)))))
        (else (cons (rember* (car lat) a) (rember* (cdr lat) a)))))

(define (occur* lat a)
  (cond ((null? lat) 0)
        ((symbol? (car lat))
         (cond ((eq? (car lat) a) (add1 (occur* (cdr lat) a )))
               (else (occur* (cdr lat) a))))
        (else (+ (occur* (car lat) a) (occur* (cdr lat) a)))))

(define (insertR* lat old new)
  (cond ((null? lat) '())
        ((symbol? (car lat))
         (cond ((eq? (car lat) old)
                (cons old (cons new (insertR* (cdr lat) old new))))
               (else (cons
                      (car lat)
                      (insertR* (cdr lat) old new)))))
        (else
         (cons
          (insertR* (car lat) old new)
          (insertR* (cdr lat) old new)))))

(define (insertL* lat old new)
  (cond ((null? lat) '())
        ((symbol? (car lat))
         (cond ((eq? (car lat) old)
                (cons old (cons new (insertL* (cdr lat) old new))))
               (else (cons
                      (car lat)
                      (insertL* (cdr lat) old new)))))
        (else
         (cons
          (insertL* (car lat) old new)
          (insertL* (cdr lat) old new)))))

(define (subst* lat a b)
  (cond ((null? lat) '())
        ((symbol? (car lat))
         (cond ((eq? (car lat) a) (cons b (subst* (cdr lat) a b)))
               (else (cons (car lat) (subst* (cdr lat) a b)))))
        (else (cons
               (subst* (car lat) a b)
               (subst* (cdr lat) a b)))))

(define (member* lat a)
  (cond ((null? lat) #f)
        ((symbol? (car lat))
         (or (eq? (car lat) a)
             (member* (cdr lat) a)))
        (else (or (member* (car lat) a) (member* (cdr lat) a)))))

(define (eqlist? l1 l2)
  (cond ((and (null? l1) (null? l2)) #t)
        ((or (null? l1) (null? l2)) #f)
        (else (and
               (equal? (car l1) (car l2))
               (equal? (cdr l2) (cdr l2))))))

(define (equal? s1 s2)
  (cond ((and (atom? s1) (atom? s2)) (equan? s1 s2))
        ((or (atom? s1) (atom? s2)) #f)
        (else (eqlist? (cdr s1) (cdr s2)))))

;; other

(define (reverse_numbers n)
  (cond ((eq? n 0) '())
        (else (cons n (reverse_numbers (sub1 n))))))

(define (reverse_num lat seq)
  (cond ((null? seq) '())
        (else (cons
               (pick lat (sub1 (car seq)))
               (reverse_num lat (cdr seq))))))

(define (reverse lat)
  (letrec ((len (length lat))
           (seq (reverse_numbers len)))
    (reverse_num lat seq)))