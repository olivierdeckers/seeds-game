module Data.Hub.Progress exposing (..)

import Config.Level exposing (allLevels, defaultLevel, world1)
import Dict
import Scenes.Hub.Types exposing (..)
import Scenes.Level.Types exposing (SeedType(..))


getSelectedProgress : InfoWindow -> Maybe LevelProgress
getSelectedProgress infoWindow =
    case infoWindow of
        Hidden ->
            Nothing

        Visible progress ->
            Just progress

        Leaving progress ->
            Just progress


getLevelConfig : LevelProgress -> Model -> ( WorldData, LevelData )
getLevelConfig ( w, l ) model =
    let
        worldData =
            allLevels |> Dict.get w

        levelData =
            worldData |> Maybe.andThen (\w -> Dict.get l w.levels)
    in
        ( worldData |> Maybe.withDefault world1
        , levelData |> Maybe.withDefault defaultLevel
        )


currentLevelSeedType : Model -> SeedType
currentLevelSeedType ({ currentLevel } as model) =
    currentLevel
        |> Maybe.map Tuple.first
        |> Maybe.andThen (\world -> Dict.get world allLevels)
        |> Maybe.map .seedType
        |> Maybe.withDefault (currentProgressSeedType model)


currentProgressSeedType : Model -> SeedType
currentProgressSeedType { progress } =
    allLevels
        |> Dict.get (Tuple.first progress)
        |> Maybe.map .seedType
        |> Maybe.withDefault Sunflower


completedLevel : ( WorldNumber, LevelNumber ) -> Model -> Bool
completedLevel ( world, level ) { progress } =
    getLevelNumber progress allLevels > getLevelNumber ( world, level ) allLevels


reachedLevel : ( WorldNumber, LevelNumber ) -> Model -> Bool
reachedLevel ( world, level ) { progress } =
    getLevelNumber progress allLevels >= getLevelNumber ( world, level ) allLevels


getLevelNumber : LevelProgress -> AllLevels -> Int
getLevelNumber ( world, level ) allLevels =
    List.range 1 (world - 1)
        |> List.foldl (\w acc -> acc + worldSize w allLevels) 0
        |> ((+) level)


worldSize : Int -> AllLevels -> Int
worldSize world allLevels =
    allLevels
        |> Dict.get world
        |> Maybe.map (.levels >> Dict.size)
        |> Maybe.withDefault 0


handleIncrementProgress : Model -> Model
handleIncrementProgress model =
    { model | progress = incrementProgress model.currentLevel model.progress allLevels }


incrementProgress : Maybe LevelProgress -> LevelProgress -> AllLevels -> LevelProgress
incrementProgress currentLevel (( world, level ) as currentProgress) allLevels =
    allLevels
        |> Dict.get world
        |> Maybe.map (compareLevels allLevels currentLevel currentProgress)
        |> Maybe.withDefault currentProgress


compareLevels : AllLevels -> Maybe LevelProgress -> LevelProgress -> WorldData -> LevelProgress
compareLevels allLevels currentLevel progress worldData =
    let
        curr =
            getLevelNumber (Maybe.withDefault ( 1, 1 ) currentLevel) allLevels

        prog =
            getLevelNumber progress allLevels
    in
        if curr >= prog then
            handleIncrement progress worldData
        else
            progress


handleIncrement : LevelProgress -> WorldData -> LevelProgress
handleIncrement (( _, level ) as currentProgress) worldData =
    if lastLevel worldData == level then
        incrementWorld currentProgress
    else
        incrementLevel currentProgress


lastLevel : WorldData -> Int
lastLevel worldData =
    Dict.size worldData.levels


incrementWorld : LevelProgress -> LevelProgress
incrementWorld ( world, _ ) =
    ( world + 1, 1 )


incrementLevel : LevelProgress -> LevelProgress
incrementLevel ( world, level ) =
    ( world, level + 1 )
