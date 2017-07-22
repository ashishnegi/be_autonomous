module Quadrant.Model exposing (..)

{-
                   Urgent  NotUrgent
                 --------------------
                 |        |         |
  Important      |  Q1    |   Q2    |
                 |        |         |
                 |--------|---------|
                 |        |         |
  NotImportant   |  Q3    |   Q4    |
                 |        |         |
                 --------------------

 -}

type Quadrant = UrgentNotImportant       --
              | ImportantNotUrgent
              | UrgentAndImportant
              | NotUrgentNotImportant




