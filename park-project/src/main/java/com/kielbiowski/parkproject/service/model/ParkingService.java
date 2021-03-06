package com.kielbiowski.parkproject.service.model;

import com.kielbiowski.parkproject.dto.ParkingDTO;
import com.kielbiowski.parkproject.dto.SpotDTO;
import com.kielbiowski.parkproject.exception.NotFoundException;
import com.kielbiowski.parkproject.model.Parking;
import com.kielbiowski.parkproject.repository.ParkingRepository;
import com.kielbiowski.parkproject.service.security.ServiceInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class ParkingService implements ServiceInterface<ParkingDTO> {

    private final ParkingRepository parkingRepository;

    @Autowired
    public ParkingService(ParkingRepository parkingRepository) {
        this.parkingRepository = parkingRepository;
    }

    @Override
    public ParkingDTO findById(Integer id) {
        return ParkingDTO.toParkingDTO(parkingRepository.findById(id).orElseThrow(NotFoundException::new));
    }

    @Override
    public ParkingDTO create(ParkingDTO parkingDTO) {
        return ParkingDTO.toParkingDTO(parkingRepository.save(ParkingDTO.toParking(parkingDTO)));
    }

    @Override
    public ParkingDTO update(ParkingDTO parkingDTO) {
        Parking entity = parkingRepository.findById(parkingDTO.getId()).orElseThrow(NotFoundException::new);
        entity.setCountry(parkingDTO.getCountry());
        entity.setZipCode(parkingDTO.getZipCode());
        entity.setCity(parkingDTO.getCity());
        entity.setStreet(parkingDTO.getStreet());
        entity.setStreetNumber(parkingDTO.getStreetNumber());
        entity.setPricePerHour(parkingDTO.getPricePerHour());
        entity.setAdminAcceptance(parkingDTO.getAdminAcceptance());
        //Null-safe stream done with Java 9' Stream.ofNullable
        entity.setSpots(Stream.ofNullable(parkingDTO.getSpotDTOs())
                .flatMap(Collection::stream)
                .map(SpotDTO::toSpot)
                .collect(Collectors.toList()));
        return ParkingDTO.toParkingDTO(parkingRepository.save(entity));
    }

    @Override
    public void delete(Integer id) {
        parkingRepository.delete(parkingRepository.findById(id).orElseThrow(NotFoundException::new));
    }
}
